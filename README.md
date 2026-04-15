## Hosts

| Host | Type | System |
|------|------|--------|
| `xmixa@thinkpad25` | WSL2 standalone Home Manager | x86_64-linux |

## Bootstrap

### Prerequisites
- WSL2 Ubuntu instance with xmixa username on thinkpad25 host
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
git clone git@github.com:christosm-dev/nix-config.git ~/.config/home-manager
cd ~/.config/home-manager
```

### 4. Apply configuration

Apply using `nix run` to avoid needing `home-manager` on PATH:

```bash
nix run nixpkgs#home-manager -- switch -b backup --flake ~/.config/home-manager#"xmixa@thinkpad25"
```

### 5. Reload shell

```bash
source ~/.bashrc
```

## Usage

```bash
# Apply config changes
home-manager switch --flake ~/.config/home-manager#"xmixa@thinkpad25"

# Add a new package — edit modules/common.nix then apply
# Add a per-project dev shell — see modules/common.nix direnv section
```
