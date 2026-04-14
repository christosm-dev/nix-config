{
  description = "xmixa home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        "xmixa@thinkpad25" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/common.nix
            ./modules/neovim.nix
            ./hosts/thinkpad25-wsl/home.nix
          ];
        };
      };
    };
}
