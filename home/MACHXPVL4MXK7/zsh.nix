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
        SYMS = "/Users/Shared/PhilipsDev/synergy/synergy-yocto-meta-synergy";
        SB = "/Users/Shared/PhilipsDev/synergy/synergy-base";
        BLURK = "/Users/Shared/PhilipsDev/synergy/synergy-base";
        MGL = "/Users/Shared/PhilipsDev/synergy/synergy-mgl-base";

        WSYB = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-yocto-build";
        WSB = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-base";
        WSYMS = "/Users/Shared/PhilipsDev/synergy/worktrees/synergy-yocto-meta-synergy";

        PEG = "/Users/phnl310181059/";
      };
      initContent = lib.mkAfter ''
        function ensure_flakehub_login() {
          if ! command -v determinate-nixd >/dev/null 2>&1 || ! command -v op >/dev/null 2>&1; then
            return 0
          fi

          if determinate-nixd status 2>/dev/null | grep -q '^Logged in: true$'; then
            return 0
          fi

          local tmp
          tmp="$(mktemp)" || return 1

          if ! op read "op://Personal/Flakehub/credential" > "$tmp" 2>/dev/null || [ ! -s "$tmp" ]; then
            rm -f -- "$tmp"
            return 1
          fi

          determinate-nixd login token --token-file "$tmp"
          local status=$?
          rm -f -- "$tmp"
          return $status
        }

        function home-manager() {
          if [ "$1" = "switch" ]; then
            ensure_flakehub_login || return $?
          fi

          command home-manager "$@"
        }

        function y() {
         	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
         	yazi "$@" --cwd-file="$tmp"
         	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        		builtin cd -- "$cwd"
        	fi
        	rm -f -- "$tmp"
        }

        toilet -f mono12  -F metal $(date +'%T')
        fastfetch
        any-nix-shell zsh --info-right | source /dev/stdin
        # cat ~/.config/yabai/yhelp 
        echo '-----------------------------------------------------------------'
        echo 'op run --env-file="./.env" <command>'
        echo '-----------------------------------------------------------------'
        cat ~/.config/aerohelp 
        			'';

    };
  };

}
