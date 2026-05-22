# forge-runbook.md

## Overview

This runbook covers restoring the homelab server from scratch on a fresh Fedora installation. Follow steps in order.

**Server:** forge.lecid.me  
**Domain:** lecid.me (managed via Cloudflare)  
**Backups:** Synology DS214 at 100.93.6.32 (Tailscale), `/Forge/backup`

---

## Step 1: Install Tailscale

Tailscale must be set up first — all server access including SSH is via Tailscale.

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --ssh
```

Log in via the Tailscale admin console to authorize the machine. Once connected, all further steps can be done over Tailscale SSH.

---

## Step 2: Bootstrap User Profile

Run the dotfiles install script to set up fish, mise, golang, tmux, and neovim:

```bash
curl -fsSL https://raw.githubusercontent.com/lecid-code/dotfiles/main/scripts/install.sh | bash
```

Log out and back in so fish shell and mise are active, then verify golang is available:

```bash
go version
```

---

## Step 3: Install Core Packages

```bash
sudo dnf install -y postgresql-server valkey restic
```

> Caddy is installed separately in Step 4 — it needs a custom binary built after DNF installation.

---

## Step 4: Build and Install Custom Caddy

Caddy must be installed via DNF first to get the systemd service, system user, and directory structure. Then replace the binary with a custom xcaddy build that includes the Cloudflare DNS plugin.

```bash
# Install via DNF first
sudo dnf install -y caddy

# Install xcaddy
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with Cloudflare module
~/go/bin/xcaddy build --with github.com/caddy-dns/cloudflare

# Stop Caddy before replacing the binary
sudo systemctl stop caddy

# Replace the binary
sudo cp caddy /usr/bin/caddy
sudo chmod 755 /usr/bin/caddy

# Verify
caddy list-modules | grep cloudflare
```

---

## Step 5: Configure Firewall

All access is via Tailscale. No ports are exposed publicly.

```bash
# Assign tailscale0 to trusted zone
sudo firewall-cmd --permanent --zone=trusted --add-interface=tailscale0

# Add Podman subnets to trusted zone
sudo firewall-cmd --permanent --zone=trusted --add-source=10.88.0.0/16
sudo firewall-cmd --permanent --zone=trusted --add-source=10.89.0.0/24

sudo firewall-cmd --reload

# Verify public zone has nothing beyond dhcpv6-client
sudo firewall-cmd --list-all
```

---

## Step 6: Verify Backup Access

Retrieve the restic repository password from Vaultwarden before proceeding.

```bash
# Create password file
sudo vim /etc/restic-password
sudo chmod 600 /etc/restic-password

# Set up SSH key for Synology access
ssh-keygen -t ed25519
ssh-copy-id rsayyid@100.93.6.32

# Verify access
ssh rsayyid@100.93.6.32

# List available snapshots
restic -r sftp:rsayyid@100.93.6.32:/Forge/backup \
    --password-file /etc/restic-password \
    snapshots
```

Note the snapshot ID you want to restore from (typically the most recent).

---

## Step 7: Restore Config Files

```bash
sudo restic -r sftp:rsayyid@100.93.6.32:/Forge/backup \
    --password-file /etc/restic-password \
    restore latest \
    --include /etc/caddy \
    --include /etc/valkey \
    --include /etc/vikunja \
    --include /etc/dnf/dnf.conf \
    --include /etc/systemd/system/caddy.service.d \
    --include /etc/containers/systemd \
    --target /
```

Lock Caddy out of DNF updates (should be restored from backup, but verify):

```bash
grep exclude /etc/dnf/dnf.conf
# Should show: exclude=caddy
```

---

## Step 8: Initialize and Restore PostgreSQL

```bash
# Initialize the database cluster
sudo postgresql-setup --initdb

# Configure PostgreSQL to listen on all interfaces
sudo vim /var/lib/pgsql/data/postgresql.conf
# Set: listen_addresses = '*'

# Configure pg_hba.conf as needed for container access
sudo vim /var/lib/pgsql/data/pg_hba.conf

# Start PostgreSQL
sudo systemctl enable --now postgresql

# Restore the PostgreSQL dump from the restic backup
restic -r sftp:rsayyid@100.93.6.32:/Forge/backup \
    --password-file /etc/restic-password \
    restore latest \
    --include /tmp/postgres_dump.sql \
    --target /

sudo -u postgres psql < /tmp/postgres_dump.sql
rm /tmp/postgres_dump.sql
```

---

## Step 9: Configure and Start Valkey

Valkey must bind to `0.0.0.0` so Podman containers can reach it via `host.containers.internal`. Config is already restored from Step 7.

Fix group permissions so restic can back up Valkey files on future runs:

```bash
sudo chgrp valkey /etc/valkey /etc/valkey/modules
sudo chgrp valkey /etc/valkey/valkey.conf /etc/valkey/sentinel.conf /etc/valkey/modules/rdma.conf
sudo usermod -aG valkey rsayyid
```

Restore Valkey data:

```bash
sudo restic -r sftp:rsayyid@100.93.6.32:/Forge/backup \
    --password-file /etc/restic-password \
    restore latest \
    --include /var/lib/valkey \
    --target /
```

Configure systemd drop-in:

```bash
sudo systemctl edit valkey
```

Add if not already present:

```ini
[Unit]
After=network-online.target

[Service]
Restart=on-failure
RestartSec=10
```

```bash
sudo systemctl enable --now valkey

# Verify it's listening on the right interface
ss -tuln | grep 6379
```

---

## Step 10: Start Native Services

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
sudo systemctl enable --now postgresql
sudo systemctl enable --now valkey
```

Verify:

```bash
sudo systemctl status caddy postgresql valkey
```

---

## Step 11: Restore Container Data Directories

```bash
sudo restic -r sftp:rsayyid@100.93.6.32:/Forge/backup \
    --password-file /etc/restic-password \
    restore latest \
    --include /var/lib/vaultwarden \
    --include /var/lib/outline \
    --include /var/lib/authentik \
    --include /var/lib/mealie \
    --include /var/lib/linkace \
    --include /var/lib/homepage \
    --target /

# Fix SELinux labels
sudo restorecon -Rv /var/lib/vaultwarden
sudo restorecon -Rv /var/lib/outline
sudo restorecon -Rv /var/lib/authentik
sudo restorecon -Rv /var/lib/mealie
sudo restorecon -Rv /var/lib/linkace
sudo restorecon -Rv /var/lib/homepage
```

---

## Step 12: Start Podman Containers

Quadlet files in `/etc/containers/systemd/` are picked up automatically by systemd.

```bash
sudo systemctl daemon-reload

sudo systemctl enable --now homepage
sudo systemctl enable --now vaultwarden
sudo systemctl enable --now vikunja
sudo systemctl enable --now outline
sudo systemctl enable --now linkace
sudo systemctl enable --now mealie
sudo systemctl enable --now it-tools
sudo systemctl enable --now authentik-server
sudo systemctl enable --now authentik-worker

# Check status
sudo systemctl status homepage vaultwarden vikunja outline linkace mealie it-tools authentik-server authentik-worker
```

---

## Step 13: Verify

```bash
# Check all services are running
systemctl list-units --type=service --state=running | grep -E "caddy|postgres|valkey|homepage|vaultwarden|vikunja|outline|linkace|mealie|authentik|it-tools"

# Check Caddy logs for TLS cert acquisition
sudo journalctl -u caddy -f

# Check firewall - public zone should only show dhcpv6-client
sudo firewall-cmd --list-all
```

Verify all services are reachable:

```bash
curl -so /dev/null -w "%{http_code} home.lecid.me\n"      https://home.lecid.me
curl -so /dev/null -w "%{http_code} auth.lecid.me\n"      https://auth.lecid.me
curl -so /dev/null -w "%{http_code} mealie.lecid.me\n"    https://mealie.lecid.me
curl -so /dev/null -w "%{http_code} docs.lecid.me\n"      https://docs.lecid.me
curl -so /dev/null -w "%{http_code} todo.lecid.me\n"      https://todo.lecid.me
curl -so /dev/null -w "%{http_code} tools.lecid.me\n"     https://tools.lecid.me
curl -so /dev/null -w "%{http_code} links.lecid.me\n"     https://links.lecid.me
curl -so /dev/null -w "%{http_code} vault.lecid.me\n"     https://vault.lecid.me
```

Expected response codes: `200` or `302` (redirect to login) for all services.

---

## Notes

- Caddy acquires TLS certificates automatically via Cloudflare DNS challenge. The `CF_API_TOKEN` is stored in the systemd drop-in at `/etc/systemd/system/caddy.service.d/`.
- Containers connect to PostgreSQL and Valkey via `host.containers.internal` which resolves to `10.89.0.1`.
- The `:Z` flag on Podman volume mounts handles SELinux labeling automatically at runtime, but `restorecon` is needed after manually restoring data directories.
- Authentik no longer requires Redis (removed in 2025.10).
- Backup runs daily at 7am UTC (2am Dallas/CDT) via cron. Retention: 7 daily, 3 monthly snapshots.
