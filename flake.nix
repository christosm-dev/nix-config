# WSL2:      home-manager switch --flake .#"xmixa@thinkpad25"
# NixOS:     sudo nixos-rebuild switch --flake .#nixbox
# T490s:     sudo nixos-rebuild switch --flake .#thinkpad-t490s
# VPS:       home-manager switch --flake .#"christos@contabo-vps"
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

      # Standalone Home Manager configurations (non-NixOS hosts)
      homeConfigurations = {

        # WSL2 instance on thinkpad25
        # username and homeDirectory are set in hosts/thinkpad25-wsl/home.nix
        "xmixa@thinkpad25" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/common.nix
            ./modules/neovim.nix
            ./hosts/thinkpad25-wsl/home.nix
          ];
        };

        # Contabo VPS - christosm.dev portfolio server
        # Docker and Traefik managed outside Nix
        "christos@contabo-vps" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/common.nix
            ./modules/neovim.nix
            ./hosts/contabo-vps/home.nix
          ];
        };

      };

      # NixOS system configurations
      # Nixbox - desktop workstation with GNOME
      nixosConfigurations = {

        # Headless local dev server
        nixbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixbox/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cm = {
                imports = [
                  ./modules/common.nix
                  ./modules/neovim.nix
                  ./hosts/nixbox/home.nix
                ];
              };
            }
          ];
        };

        # ThinkPad T490s - desktop workstation with GNOME
        thinkpad-t490s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/thinkpad-t490s/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cm = {
                imports = [
                  ./modules/common.nix
                  ./modules/neovim.nix
                  ./hosts/thinkpad-t490s/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
