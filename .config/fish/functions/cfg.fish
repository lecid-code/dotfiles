function cfg --wraps git --description 'Manage dotfiles with git'
    git --git-dir=$HOME/.cfg --work-tree=$HOME $argv
end
