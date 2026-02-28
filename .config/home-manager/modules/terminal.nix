{ pkgs, ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [ "--group-directories-first" "--color=auto" ];
  };

  programs.fastfetch.enable = true;
  programs.atuin.enable = true;
  programs.navi.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes,header";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
