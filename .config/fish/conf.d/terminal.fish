if status is-interactive
    set -q fish_key_bindings; or set -g fish_key_bindings fish_default_key_bindings

    fish_add_path --path $HOME/.local/bin
    fish_add_path /usr/sbin /usr/local/sbin ~/bin
    fish_add_path "/home/rsayyid/.bun/bin"

    command -q mise && mise activate fish | source
    command -q fzf && fzf --fish | source
    command -q zoxide && zoxide init fish | source
end
