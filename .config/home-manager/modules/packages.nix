{ config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    gh          # Github CLI
    glab        # Gitlab CLI
    fd          # faster alternative to find
    jq          # JSON query parser
    yq-go       # YAML parser
    procs       # Modern replacement to ps
    btop        # Resource monitor
    ripgrep     # Faster grep
    tealdeer    # Example based manpages
    gping       # Ping with a graph
    duf         # How much free space is available
    dust        # Find out what is using space
    hyperfine   # Command line benchmarking tool
    usage       # Needed for mise completions to work
    mise        # Package manager - mainly used for dev tools
  ];
}
