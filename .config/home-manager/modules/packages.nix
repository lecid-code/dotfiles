{ config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    gh
    glab
    fd
    jq
    yq-go
    procs
    bottom
    lazygit
    ripgrep
    tealdeer
    gping
    duf
    dust
    hyperfine
    usage
    mise
  ];
}
