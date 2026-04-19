# hosts/nixbox/configuration.nix
# NixOS system configuration for nixbox.
# Headless local dev server, accessed via SSH only.
# Apply with: sudo nixos-rebuild switch --flake .#nixbox
{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true; 

  imports = [
    ./hardware-configuration.nix  # generated during nixos-install
  ];

  # Bootloader
  boot.loader.grub.device = "/dev/sda";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixbox";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Docker - runs as a system service
  # cm user is added to docker group for non-root access
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # User account
  # Password is set separately with passwd after first boot
  users.users.cm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.bash;
  };

  # Allow sudo for wheel group
  security.sudo.wheelNeedsPassword = true;

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;  # key-based auth only
      PermitRootLogin = "no";
    };
  };

  # Open SSH port in firewall
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Common system packages
  # User packages are managed by Home Manager
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim  # fallback editor before home-manager is applied
  ];

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
