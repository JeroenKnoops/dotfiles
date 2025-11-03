{
  description = "Multi Machine Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwdc.url = "github:JeroenKnoops/pwdc";
    dotfile = {
      url = "git+https://github.com/jeroenknoops/dotfiles.git";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, pwdc, dotfiles, ... }@inputs: {

      homeConfigurations = {
        "jeroenknoops@sh101" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ 
            ./home/sh101-home.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        "phnl310118059@MACHXPVL4MXK7" = home-manager.lib.homeManagerConfiguration {
          system = "aarch64-darwin";
          host = "MACHXPVL4MXK7";
          pkgs = import nixpkgs { system = ${system}; };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ 
            ./home/${host}/home.nix 
            ./home/${host}/git.nix 
            ./home/${host}/zsh.nix 
            ./home/${host}/tmux.nix 
            ./home/${host}/darwin-aerospace.nix 
            ./home/${host}/oh-my-posh.nix
            ./home/${host}/dotfiles.nix
            pwdc.homeModules.${system}.default
          ];

          
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit inputs;
            pwdcPackage = pwdc.packages.${system}.default;
          };
      };
    };
}
