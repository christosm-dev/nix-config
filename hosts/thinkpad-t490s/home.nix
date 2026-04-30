# hosts/thinkpad-t490s/home.nix
# Home Manager configuration specific to ThinkPad T490s.
# Desktop workstation - no WSL2 workarounds needed.
# username and homeDirectory are inferred automatically by NixOS Home Manager module.
{ pkgs, ... }: {

  home.stateVersion = "24.11";

  # Desktop-specific packages
  home.packages = with pkgs; [
    firefox           # primary browser
    vscode            # GUI editor
    alacritty         # terminal emulator
    vlc               # media player
  ];
}
