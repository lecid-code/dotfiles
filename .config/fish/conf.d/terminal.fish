if status is-interactive
    # Ensure key bindings variable is set before atuin
    set -q fish_key_bindings; or set -g fish_key_bindings fish_default_key_bindings

    command -q mise && mise activate fish | source
    command -q mise && mise completions fish | source
    command -q atuin && atuin init fish | source
    command -q navi && navi widget fish | source
    command -q fzf && fzf --fish | source
    command -q zoxide && zoxide init fish | source
end
