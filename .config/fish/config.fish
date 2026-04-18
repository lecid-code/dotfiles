# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GOPATH $HOME/.go
set -gx PAGER less
# set -gx MANPAGER less
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx FZF_DEFAULT_OPTS "-m --bind='ctrl-o:execute(nvim {})+abort'"
set -gx FZF_DEFAULT_COMMAND "rg --files"
set -gx BAT_THEME Nord

# PATH
fish_add_path $HOME/bin
fish_add_path $HOME/.go/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.bun/bin

# Abbreviations
abbr --add vi nvim
abbr --add l "eza --long --all --git"
abbr --add ls "eza"
abbr --add cat bat
abbr --add grep "grep --color=auto"
abbr --add lg lazygit
abbr --add now TZ="America/Chicago" date
