# flake.nix
# Entrypoint for the nix-config flake.
# Defines all host configurations and wires together shared modules.
# To apply: home-manager switch --flake .#"xmixa@<hostname>"
{
  description = "xmixa home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # use same nixpkgs as above
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {

        # WSL2 instance on thinkpad25
        # Applies: common.nix + neovim.nix + WSL2-specific overrides
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
