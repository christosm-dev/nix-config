# hosts/contabo-vps/home.nix
# Standalone Home Manager configuration for Contabo VPS.
# Hosts christosm.dev portfolio services via Docker + Traefik.
# Docker and system services are managed outside Nix via apt.
# Apply with: home-manager switch -b backup --flake .#"christos@contabo-vps"
{ pkgs, ... }: {

  home.username = "christos";
  home.homeDirectory = "/home/christos";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

  # Monitoring and server management tools
  home.packages = with pkgs; [
    tmux
    htop
    ncdu
    iftop
    nethogs
    glances
  ];
}
