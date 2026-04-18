# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH $HOME/.go
set -gx PAGER less
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"
set -gx LC_ALL en_US.UTF-8
set -gx FZF_DEFAULT_OPTS "-m --bind='ctrl-o:execute(nvim {})+abort'"
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
set -gx BAT_THEME Nord

# Abbreviations
abbr --add vi nvim
abbr --add l "eza --long --all --git"
abbr --add ls "eza"
abbr --add cat bat
abbr --add grep rg
abbr --add lg lazygit
abbr --add batr "fd --type f --exec bat --style=header,grid"
