{
  config,
  pkgs,
  lib,
  ...
}:
{

  programs = {
    yazi = {
      enable = true;
    };
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "gh"
          "wd"
          "history"
          "z"
        ];
      };
      shellAliases = {
        t = "toilet -f mono12  -F metal $(date +'%T')";
        glog = "git log --pretty=format:'%C(yellow)%h%C(reset) %C(green)%ar%C(reset) %C(bold blue)%an%C(reset) %C(red)%d%C(reset) %s' --graph --abbrev-commit --decorate";
        gbrm = "git branch --merged | grep -v \"\*\" | xargs -n 1 git branch -d";
        yhelp = "cat ~/.config/yabai/yhelp";
        aerohelp = "cat ~/.config/aerohelp";
        ":q" = "exit";
        "@@e" = "$($(fc -ln -1) |& tail -1)";
        "@@" = "echo $(fc -ln -1) |& tail -1";
      };
      dirHashes = {
        crypt = "/Users/Shared/PhilipsDev/crypt";
        PS = "~/workspace/philips-software";
        PI = "~/workspace/philips-internal";
        PF = "~/workspace/philips-forks";
        JK = "/Users/phnl310181059/workspace/jeroenknoops";
        PD = "/Users/Shared/PhilipsDev";

        SYN = "/Users/Shared/PhilipsDev/synergy";
        SA = "/Users/Shared/PhilipsDev/synergy/synergy-auth";
        SD = "/Users/Shared/PhilipsDev/synergy/synergy-doc";
        SYB = "/Users/Shared/PhilipsDev/synergy/synergy-yocto-build";
        SB = "/Users/Shared/PhilipsDev/synergy/synergy-base";
        BLURK = "/Users/Shared/PhilipsDev/synergy/synergy-base";
        SYMS = "/Users/Shared/PhilipsDev/synergy/synergy-yocto-meta-synergy";
        MGL = "/Users/Shared/PhilipsDev/synergy/synergy-mgl-base";

        WSYB = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-yocto-build";
        WSB = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-base";
        WSYMS = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-yocto-meta-synergy";

        PEG = "/Users/phnl310181059/";
      };
      initContent = ''
        function y() {
        	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        	yazi "$@" --cwd-file="$tmp"
        	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        		builtin cd -- "$cwd"
        	fi
        	rm -f -- "$tmp"
        }

        toilet -f mono12  -F metal $(date +'%T')
        neofetch
        any-nix-shell zsh --info-right | source /dev/stdin
        # cat ~/.config/yabai/yhelp 
        cat ~/.config/aerohelp 
        			'';

    };
  };

}
