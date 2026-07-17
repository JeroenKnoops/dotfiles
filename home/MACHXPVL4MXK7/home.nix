{
  config,
  pkgs,
  lib,
  inputs,
  nix-index-database,
  lolcommits,
  opencode,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "phnl310181059";
  home.homeDirectory = "/Users/phnl310181059";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  imports = [
    ./git-find-build.nix
  ];

  home.file.".config/nvim" = {
    source = "${inputs.dotfiles}/nvim";
    recursive = true;
  };

  # home.packages = with pkgsUnstable; [
  home.packages = [
    pkgs.aerospace
    pkgs.any-nix-shell
    pkgs.cacert
    pkgs.cargo
    pkgs.chafa
    pkgsUnstable.cmux
    pkgs.devbox
    pkgs.docker
    pkgs.docker-buildx
    pkgs.fastfetch
    pkgs.fd
    pkgs.fh
    pkgs.fly
    pkgs.fzf
    pkgs.git
    #      pkgs.gitbutler
    pkgs.gnugrep
    pkgs.graphviz
    pkgs.gti
    pkgs.jq
    pkgs.jujutsu
    pkgs.kubo
    pkgs.maccy
    pkgs.nerd-fonts.fantasque-sans-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.inconsolata
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.roboto-mono
    pkgs.nil
    pkgs.nixfmt
    pkgs.nodejs
    # opencode
    pkgsUnstable.opencode
    pkgs.pi-coding-agent
    pkgs.pipenv
    pkgs.protobuf
    pkgs.python313
    pkgs.python313Packages.pip
    pkgs.qemu
    pkgs.ratchet
    pkgs.ripgrep
    pkgs.secretspec
    pkgs.stack
    pkgs.stow
    pkgs.tmux
    pkgs.toilet
    pkgs.typescript
    pkgs.virtualenv
    pkgs.vscode
    pkgs.watch
    pkgs.wget
    pkgs.yq-go
    pkgs.zld
    pkgs.zsh
    pkgs.zsh-syntax-highlighting
    lolcommits
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
    # I like DIRENV to be silent
    DIRENV_LOG_FORMAT = "";
  };

  programs = {
    home-manager.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
      withRuby = false;
      withPython3 = false;
      plugins = with pkgs.vimPlugins; [
      ];
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    pwdc.enable = true;

    git.findBuild = {
      enable = true;
      notesRef = "refs/notes/commits";
    };

    bat.enable = true;
    # starship.enable = true;
    lazygit = {
      enable = true;
      settings = {
        git.signOff = true;
        git.branchLogCmd = "git log --first-parent --oneline --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset' --date=format-local:'%Y-%m-%d %H:%M'";
      };
    };
    eza = {
      enable = true;
      git = true;
    };
    tmux = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-index-database = {
      comma = {
        enable = true;
      };
    };
  };

}
