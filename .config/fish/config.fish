if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path -p -g $HOME/.go/bin
    fish_add_path -p -g $HOME/.local/bin
    fish_add_path -p -g $HOME/bin
    fish_add_path -p -g $HOME/.bun/bin
end

/home/rsayyid/.local/bin/mise activate fish | source # added by https://mise.run/fish

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# go
set -x -U GOPATH $HOME/.go
