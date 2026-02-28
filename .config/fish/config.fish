# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH $HOME/.go
set -gx LESS "-RSM~gIsw"
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx FZF_DEFAULT_OPTS "-m --bind='ctrl-o:execute(nvim {})+abort'"
set -gx FZF_DEFAULT_COMMAND "rg --files"
set -gx BAT_THEME Dracula

# PATH
fish_add_path $HOME/.go/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.bun/bin

# Abbreviations
abbr --add vi nvim
abbr --add l "eza --long --all --git"
abbr --add cat bat
abbr --add grep "grep --color=auto"
abbr --add df duf
abbr --add du dust
abbr --add ps procs
abbr --add lg lazygit
abbr --add hme "home-manager edit"
abbr --add hms "home-manager switch"

# Interactive shell init
if status is-interactive
    mise activate fish | source
    mise completions fish | source
end

# Login shell init
if status is-login
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end
