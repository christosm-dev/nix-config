# hosts/nixbox/home.nix
# Home Manager configuration specific to nixbox.
# NixOS host - no WSL2 workarounds needed.
# username and homeDirectory are inferred automatically by NixOS Home Manager module.
{ pkgs, ... }: {

  home.username = "cm";
  home.homeDirectory = "/home/cm";

  home.stateVersion = "24.11";

  # Fix headless boot - disable NetworkManager wait online service
  # which can block boot when no display is connected
  systemd.services.NetworkManager-wait-online.enable = false;

  # Ensure network is brought up regardless of display connection
  networking.networkmanager.wait-online.enable = false;

  # Common config is inherited from modules/common.nix and modules/neovim.nix.
}
