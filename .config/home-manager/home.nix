{ config, pkgs, ... }:
{
  home.username = "rsayyid";
  home.homeDirectory = "/home/rsayyid";
  home.stateVersion = "25.11";

  imports = [
    ./modules/packages.nix
    # ./modules/shell.nix
    ./modules/git.nix
    #./modules/editor.nix
    ./modules/terminal.nix
  ];

  programs.home-manager.enable = true;
}
