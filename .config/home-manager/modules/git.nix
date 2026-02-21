{ config, pkgs, ... }:
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "Dracula";
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv"
      ".envrc"
      "fish_variables"
      "lazyvim.json"
    ];
    settings = {
      user.name = "Ramzi Sayyid";
      user.email = "code@lecid.me";
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        lg = "log --oneline --graph --decorate --all";
        undo = "reset HEAD~1 --mixed";
        wip = "commit -am 'wip'";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      core.autocrlf = "input";
    };
  };
}
