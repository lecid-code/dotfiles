function load_env
    for line in (cat .env | string trim)
        if string match -q --regex '^#' $line; continue; end
        if string match -q --regex '^\s*$' $line; continue; end
        set --export (string split '=' $line)[1] (string split '=' $line)[2]
    end
end
