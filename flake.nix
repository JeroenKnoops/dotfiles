{
  description = "Multi Machine Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pwdc.url = "github:JeroenKnoops/pwdc";
    dotfiles = {
      url = "git+https://github.com/jeroenknoops/dotfiles.git";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lolcommits-flake.url = "github:JeroenKnoops/lolcommits-flake";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      fh,
      pwdc,
      dotfiles,
      nix-index-database,
      lolcommits-flake,
      ...
    }@inputs:
    {

      homeConfigurations = {
        "jeroenknoops@sh101" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };

          modules = [
            {
              environment.systemPackages = [ fh.packages.x86_64-linux.default ];
            }
            ./home/sh101-home.nix
          ];
        };

        "phnl310118059@MACHXPVL4MXK7" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "aarch64-darwin"; };

          modules = [
            ./home/MACHXPVL4MXK7/home.nix
            ./home/MACHXPVL4MXK7/git.nix
            ./home/MACHXPVL4MXK7/zsh.nix
            ./home/MACHXPVL4MXK7/darwin-aerospace.nix
            ./home/MACHXPVL4MXK7/oh-my-posh.nix
            ./home/MACHXPVL4MXK7/dotfiles.nix
            pwdc.homeModules."aarch64-darwin".default
            nix-index-database.homeModules.default
          ];

          extraSpecialArgs = {
            inherit inputs;
            pwdcPackage = pwdc.packages."aarch64-darwin".default;
            lolcommits = lolcommits-flake.packages."aarch64-darwin".default;
          };
        };
      };
    };
}
