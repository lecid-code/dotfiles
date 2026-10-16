function srg --description 'ripgrep as root, with my config'
    set -l envs
    set -q RIPGREP_CONFIG_PATH; and set -a envs RIPGREP_CONFIG_PATH=$RIPGREP_CONFIG_PATH
    sudo env $envs (mise which rg) $argv
end
