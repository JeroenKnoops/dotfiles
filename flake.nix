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
    dotfiles = {
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
          pkgs = import nixpkgs { system = "aarch64-darwin"; };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ 
            ./home/MACHXPVL4MXK7/home.nix 
            ./home/MACHXPVL4MXK7/git.nix 
            ./home/MACHXPVL4MXK7/zsh.nix 
            ./home/MACHXPVL4MXK7/darwin-aerospace.nix 
            ./home/MACHXPVL4MXK7/oh-my-posh.nix
            ./home/MACHXPVL4MXK7/dotfiles.nix
            pwdc.homeModules."aarch64-darwin".default
          ];

          
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit inputs;
            pwdcPackage = pwdc.packages."aarch64-darwin".default;
          };
      };
    };
  };
}
