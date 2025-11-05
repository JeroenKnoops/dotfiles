{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      userEmail = "jeroen.knoops@philips.com";
      userName = "Jeroen Knoops";
      aliases = {
        cm = "commit";
        ca = "commit --amend --no-edit";
        ps = "push";
        pf = "push --force-with-lease";
        st = "status -sb";
        fplt = "log --first-parent --oneline --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset' --date=format-local:'%Y-%m-%d %H:%M'";
        fpl = "log --first-parent --oneline --decorate-refs-exclude=refs/tags --decorate-refs-exclude=refs/remotes --decorate-refs-exclude=refs/heads --decorate-refs-exclude=HEAD --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset' --date=format-local:'%Y-%m-%d %H:%M'";
        build-current = "for-each-ref --sort=-creatordate --format '%(refname:short) %(color:yellow)%(objectname:short) %(color:yellow)%(*objectname:short) %(color:blue)%(creatordate:iso) %(color:green)(%(creatordate:relative))%(color:reset)' --count=10 'refs/tags/synergy-yocto-build-current*'";
        build-stable = "for-each-ref --sort=-creatordate --format '%(refname:short) %(color:yellow)%(objectname:short) %(color:yellow)%(*objectname:short) %(color:blue)%(creatordate:iso) %(color:green)(%(creatordate:relative))%(color:reset)' --count=10 'refs/tags/synergy-yocto-build-stable*'";
        build-release = "for-each-ref --sort=-creatordate --format '%(refname:short) %(color:yellow)%(objectname:short) %(color:yellow)%(*objectname:short) %(color:blue)%(creatordate:iso) %(color:green)(%(creatordate:relative))%(color:reset)' --count=10 'refs/tags/synergy-yocto-build-v*'";
      };
      ignores = [
        ".idea" ".vs" ".vsc" ".vscode" # ide
        ".DS_Store" # mac
        "node_modules" "npm-debug.log" # npm
      ];
      extraConfig = {
        init = { defaultBranch = "main"; };
        pull = {
          ff = false;
          commit = false;
          rebase = true;
        };
        delta = {
          line-numbers = true;
        };
      };
      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6uhyzK5oy4CHVGAadwbop1m2hOIQZWLuTqvLXG3PY+";
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
    gh = {
      enable = true;
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
          explain = "copilot explain";
          suggest = "copilot suggest";
        };
        editor = "nvim";
        pager = "cat";
        prompt = "enable";
        git_protocol = "ssh";
      };
    };
  };
  #  home.activation.installGhCopilot = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #  if ! gh extension list | grep -q github/gh-copilot; then
  #    gh extension install github/gh-copilot
  #  fi
  # '';
}
