{
  description = "Home Manager configuration of phnl310181059";

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
    { nixpkgs, home-manager, pwdc, dotfiles, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."phnl310181059" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          ./home.nix 
          ./git.nix 
          ./zsh.nix 
          ./tmux.nix 
          ./darwin-aerospace.nix 
          ./oh-my-posh.nix
          ./dotfiles.nix
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
