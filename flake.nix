{
  description = "Multi Machine Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    supacode = {
      url = "path:./common/supacode";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";

  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      fh,
      pwdc,
      nix-index-database,
      lolcommits-flake,
      supacode,
      hermes-agent,
      ...
    }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in
    {

      homeConfigurations = {
        "jeroenknoops@sh101" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = linuxSystem; };

          modules = [
            {
              home.packages = [ fh.packages.${linuxSystem}.default ];
            }
            ./home/sh101-home.nix
          ];
        };

        "phnl310118059@MACHXPVL4MXK7" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = darwinSystem; };

          modules = [
            ./home/MACHXPVL4MXK7/home.nix
            ./home/MACHXPVL4MXK7/git.nix
            ./home/MACHXPVL4MXK7/zsh.nix
            ./home/MACHXPVL4MXK7/darwin-aerospace.nix
            ./home/MACHXPVL4MXK7/oh-my-posh.nix
            ./home/MACHXPVL4MXK7/dotfiles.nix
            ./home/MACHXPVL4MXK7/1password.nix
            {
              home.packages = [
                supacode.packages.${darwinSystem}.supacode
                hermes-agent.packages.${darwinSystem}.default
              ];
            }
            pwdc.homeModules."aarch64-darwin".default
            nix-index-database.homeModules.default
          ];

          extraSpecialArgs = {
            inherit inputs;
            pwdcPackage = pwdc.packages.${darwinSystem}.default;
            lolcommits = lolcommits-flake.packages.${darwinSystem}.default;
          };
        };
      };
    };
}
