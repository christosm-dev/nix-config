# hosts/nixbox/home.nix
# Home Manager configuration specific to nixbox.
# NixOS host - no WSL2 workarounds needed.
# username and homeDirectory are inferred automatically by NixOS Home Manager module.
{ pkgs, ... }: {

  home.username = "cm";
  home.homeDirectory = "/home/cm";

  home.stateVersion = "24.11";

  # No host-specific overrides needed yet.
  # Common config is inherited from modules/common.nix and modules/neovim.nix.
}
