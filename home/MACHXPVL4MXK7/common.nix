{ config, pkgs, inputs, ... }:

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

  home.file.".config/nvim" = {
    source  = "${inputs.dotfiles}/nvim";
    recursive = true;
  };

  # home.packages = with pkgsUnstable; [
    home.packages = [
      pkgs.aerospace
      pkgs.any-nix-shell
      pkgs.cacert
      pkgs.cargo
      pkgs.devbox
      pkgs.direnv
      pkgs.docker
      pkgs.docker-buildx
      pkgs.fd
      pkgs.fly
      pkgs.fzf
      pkgs.git
    #      pkgs.gitbutler
      pkgs.gnugrep
      pkgs.graphviz
      pkgs.gti
      pkgs.jq
      pkgs.maccy
      pkgs.neofetch
      pkgs.nil
      pkgs.ratchet
      pkgs.protobuf
      pkgs.python313
      pkgs.python313Packages.pip
      pkgs.pipenv
      pkgs.qemu
      pkgs.ripgrep
      pkgs.stack
      pkgs.stow
      pkgs.tmux
      pkgs.toilet
      pkgs.typescript
      pkgs.virtualenv
      pkgs.vscode
      pkgs.watch
      pkgs.wget
      pkgs.yazi
      pkgs.yq-go
      pkgs.zellij
      pkgs.zld
      pkgs.zsh
      pkgs.zsh-syntax-highlighting
      pkgs.jujutsu
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.inconsolata
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.roboto-mono
      pkgs.nerd-fonts.fantasque-sans-mono
      pkgs.nerd-fonts.hack
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
      plugins = with pkgs.vimPlugins; [
      ];
    };

    pwdc.enable = true;

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
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

}
