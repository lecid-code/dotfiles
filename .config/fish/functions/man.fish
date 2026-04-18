function man --wraps man --description 'Format and display manual pages'
    set -lx MANPATH (string join : $MANPATH)
    if test -z "$MANPATH"
        type -q manpath
        and set MANPATH (command manpath)
    end

    set -l fish_data_dir $__fish_data_dir
    set -l fish_manpath (dirname $fish_data_dir)/fish/man
    if test -d "$fish_manpath" -a -n "$MANPATH"
        set MANPATH "$fish_manpath":$MANPATH
        command man $argv
        return
    end
    command man $argv
end
