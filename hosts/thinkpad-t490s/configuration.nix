# hosts/thinkpad-t490s/configuration.nix
# NixOS system configuration for ThinkPad T490s.
# Desktop workstation with GNOME, dual boot alongside Windows on separate drive.
# Apply with: sudo nixos-rebuild switch --flake .#thinkpad-t490s
{ config, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix  # generated during nixos-install
  ];

  # Bootloader — UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;  # time to select OS on dual boot

  # Networking
  networking.hostName = "thinkpad-t490s";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # GNOME desktop environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable sound via PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ThinkPad-specific hardware support
  services.thermald.enable = true;        # thermal management
  services.tlp.enable = true;             # battery/power management
  hardware.trackpoint.enable = true;      # ThinkPad trackpoint
  hardware.trackpoint.emulateWheel = true;

  # User account
  users.users.cm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
    shell = pkgs.bash;
  };

  # Allow sudo for wheel group
  security.sudo.wheelNeedsPassword = true;

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Common system packages
  # User packages managed by Home Manager
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    gnome-tweaks      # GNOME customisation
    chromium          # fallback browser
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "24.11";
}
