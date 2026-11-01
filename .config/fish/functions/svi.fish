function svi --description 'nvim as root, with my config and plugins'
    sudo env XDG_CONFIG_HOME=$HOME/.config XDG_DATA_HOME=$HOME/.local/share (mise which nvim) $argv
    # give back anything root created in my nvim dirs (plugin installs, lazy-lock.json)
    sudo find $HOME/.config/nvim $HOME/.local/share/nvim -user root -exec chown (id -u):(id -g) '{}' + 2>/dev/null
end
