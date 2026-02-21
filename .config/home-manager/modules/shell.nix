{ config, pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GOPATH = "$HOME/.go";
    LESS = "-RSM~gIsw";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    FZF_DEFAULT_OPTS = "-m --bind='ctrl-o:execute(nvim {})+abort'";
    FZF_DEFAULT_COMMAND = "rg --files";
    BAT_THEME = "Dracula";
  };

  home.sessionPath = [
    "$HOME/.go/bin"
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.bun/bin"
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      hme = "home-manager edit";
    };
    functions = {
      hms = ''
        home-manager switch && cfg add ~/.config/home-manager/ && cfg commit -m "home-manager: $argv[1]"
      '';
      cfg = "git --git-dir=$HOME/.cfg --work-tree=$HOME $argv";
    };
    interactiveShellInit = ''
      /home/rsayyid/.local/bin/mise activate fish | source
    '';
    loginShellInit = ''
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    '';
    shellAbbrs = {
      vi = "nvim";
      l = "eza --long --all --git";
      cat = "bat";
      grep = "grep --color=auto";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 500;
      git_branch.symbol = " ";
      directory.truncation_length = 3;
      nix_shell.symbol = "❄️ ";
    };
  };
}
