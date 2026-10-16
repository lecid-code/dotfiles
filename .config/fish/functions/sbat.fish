function sbat --description 'bat as root, with my config and themes'
    sudo env BAT_THEME=$BAT_THEME BAT_CONFIG_PATH=(bat --config-file) BAT_CACHE_PATH=(bat --cache-dir) (mise which bat) $argv
end
