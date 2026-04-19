# nix-config

Declarative home environment using [Nix](https://nixos.org/) and
[Home Manager](https://github.com/nix-community/home-manager).

## Structure

```
.
├── flake.nix                           # Entrypoint, defines all host configurations
├── flake.lock                          # Pinned dependency versions
├── modules/
│   ├── common.nix                      # Shared config across all hosts
│   └── neovim.nix                      # Neovim + LSP configuration
└── hosts/
    ├── thinkpad25-wsl/
    │   └── home.nix                    # WSL2-specific overrides
    └── nixbox/
        ├── configuration.nix           # NixOS system configuration
        ├── hardware-configuration.nix  # Generated during install
        └── home.nix                    # nixbox-specific Home Manager overrides
```

## Hosts

| Host | Type | User | System |
|------|------|------|--------|
| `xmixa@thinkpad25` | WSL2 standalone Home Manager | xmixa | x86_64-linux |
| `nixbox` | NixOS + Home Manager module | cm | x86_64-linux |

## Bootstrap — WSL2

### Prerequisites

- WSL2 Ubuntu instance
- SSH key at `~/.ssh/id_ed25519` configured for GitHub

### 1. Install Nix (multi-user)

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Enable flakes

```bash
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon
```

### 3. Clone repo

```bash
git clone https://github.com/christosm-dev/nix-config.git ~/.config/home-manager
```

### 4. Apply configuration

```bash
nix run nixpkgs#home-manager -- switch -b backup --flake ~/.config/home-manager#"xmixa@thinkpad25"
```

Home Manager will automatically back up any conflicting files (e.g. `.bashrc.backup`, `.profile.backup`).

### 5. Reload shell

```bash
source ~/.bashrc
```

## Bootstrap — NixOS (nixbox)

### Prerequisites

- NixOS minimal ISO flashed to USB
- SSH key at `~/.ssh/id_ed25519`

### 1. Boot NixOS live environment and partition drive

```bash
# Format partitions
sudo mkfs.fat -F 32 /dev/sda1   # EFI partition
sudo mkfs.ext4 /dev/sda2         # root partition

# Mount partitions
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/sda1 /mnt/boot
```

### 2. Generate hardware configuration

```bash
sudo nixos-generate-config --root /mnt
```

Copy `/mnt/etc/nixos/hardware-configuration.nix` to `hosts/nixbox/` in the repo and commit it.

### 3. Install NixOS

```bash
# Clone repo and copy configuration
git clone https://github.com/christosm-dev/nix-config.git /tmp/nix-config
sudo cp /tmp/nix-config/hosts/nixbox/configuration.nix /mnt/etc/nixos/configuration.nix
sudo cp /tmp/nix-config/hosts/nixbox/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix

# Install
sudo nixos-install
```

### 4. First boot

After rebooting into NixOS, log in as `root` and set the `cm` user password:

```bash
passwd cm
```

Add your SSH public key:

```bash
mkdir -p /home/cm/.ssh
echo "your-public-key" > /home/cm/.ssh/authorized_keys
chmod 700 /home/cm/.ssh
chmod 600 /home/cm/.ssh/authorized_keys
chown -R cm:users /home/cm/.ssh
```

### 5. Apply configuration

SSH in as `cm` and clone the repo:

```bash
git clone https://github.com/christosm-dev/nix-config.git ~/.config/home-manager
sudo nixos-rebuild switch --flake ~/.config/home-manager#nixbox
```

## Usage

```bash
# Apply config changes on WSL2
home-manager switch --flake ~/.config/home-manager#"xmixa@thinkpad25"

# Apply config changes on nixbox
sudo nixos-rebuild switch --flake ~/.config/home-manager#nixbox
```
