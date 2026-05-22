#!/bin/bash
set -euo pipefail

RESTIC_REPO="sftp:rsayyid@100.93.6.32:/Forge/backup"
RESTIC_PASSWORD_FILE="/etc/restic-password"
PG_DUMP="/tmp/postgres_dump.sql"

# Dump PostgreSQL
echo "Dumping PostgreSQL..."
pg_dumpall -U rsayyid >"$PG_DUMP"

# Run restic backup
echo "Running restic backup..."
restic -r "$RESTIC_REPO" --password-file "$RESTIC_PASSWORD_FILE" backup \
  /etc/containers/systemd \
  /etc/caddy \
  /etc/systemd/system/caddy.service.d \
  /etc/valkey \
  /etc/vikunja \
  /etc/dnf/dnf.conf \
  /var/lib/vaultwarden \
  /var/lib/outline \
  /var/lib/authentik \
  /var/lib/mealie \
  /var/lib/linkace \
  /var/lib/homepage \
  /var/lib/valkey \
  "$PG_DUMP"

# Clean up PostgreSQL dump
rm "$PG_DUMP"

# Prune old snapshots - keep 7 daily, 3 monthly
echo "Pruning old snapshots..."
restic -r "$RESTIC_REPO" --password-file "$RESTIC_PASSWORD_FILE" forget \
  --keep-daily 7 \
  --keep-monthly 3 \
  --prune

echo "Backup complete."
