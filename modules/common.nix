# modules/common.nix
# Shared configuration applied to all hosts.
# Contains packages, tools and settings that are host-agnostic.
{ pkgs, ... }: {

  home.username = "xmixa";
  home.homeDirectory = "/home/xmixa";

  # Keep this at the version when Home Manager was first installed.
  # Changing it may trigger breaking changes in module defaults.
  home.stateVersion = "23.11";

  # Allow proprietary packages where needed
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Common packages available on all hosts
  home.packages = with pkgs; [
    curl
    wget
    ripgrep    # fast grep replacement, used by Neovim live grep
    fd         # fast find replacement
    bat        # syntax-highlighted cat replacement
    eza        # modern ls replacement
    fzf        # fuzzy finder
    jq         # JSON processor
    opentofu   # Terraform 
  ];

  # Bash — aliases, history and environment
  programs.bash = {
    enable = true;
    historySize = 10000;
    historyFileSize = 100000;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ls  = "eza";
      ll  = "eza -la";
      lt  = "eza --tree";
      cat = "bat";
      g   = "git";
      k   = "kubectl";
      tf  = "opentofu";
      nv  = "nvim";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # direnv — auto-activates Nix dev shells on cd
  # nix-direnv provides faster, cached shell activation
  # Usage: add 'use flake' to .envrc in any project with a flake.nix
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Starship — cross-shell prompt
  # Shows git branch, Nix shell status, directory and command result
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      # Show active Nix dev shell in prompt
      nix_shell = {
        disabled = false;
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        unknown_msg = "[unknown](bold yellow)";
        format = "via [❄️ $state( $name)](bold blue) ";
      };
      git_branch = {
        format = "on [($branch)](bold purple) ";
      };
    };
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      "\e[A": history-search-backward
      "\e[B": history-search-forward
    '';
  };

  # Git — identity and sensible defaults
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name = "Christos";
      user.email = "christosm-dev@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;          # rebase instead of merge on pull
      push.autoSetupRemote = true; # auto-create remote tracking branch
      core.editor = "nvim";
    };
    ignores = [
      ".DS_Store"       # macOS metadata
      "*.swp"           # Vim swap files
      ".direnv"         # direnv environment cache
      ".env"            # local environment variables
    ];
  };

  # SSH — declarative host config
  # Private keys are managed manually in ~/.ssh/ and never stored in Nix
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      # Contabo VPS — replace hostname with actual domain if DNS is configured
      "vps" = {
        hostname = "94.72.96.38";
        user = "christos";
        port = 49153;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
