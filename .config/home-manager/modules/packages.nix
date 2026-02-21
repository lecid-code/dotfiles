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
    tealdeer
    gping
    duf
    dust
    hyperfine
  ];
}
