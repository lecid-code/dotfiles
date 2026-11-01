function srclone --wraps=rclone --description 'rclone as root with /etc/rclone config'
    sudo rclone --config /etc/rclone/rclone.conf $argv
end
