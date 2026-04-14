{ pkgs, ... }: {

  home.username = "xmixa";
  home.homeDirectory = "/home/xmixa";
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

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
      tf  = "terraform";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      nix_shell = {
        disabled = false;
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        unknown_msg = "[unknown](bold yellow)";
        format = "via [❄️ $state( $name)](bold blue) ";
      };
      git_branch = {
        symbol = " ";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "vps" = {
        hostname = "94.72.96.38";
        user = "christos";
        port = 49153;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.git = {
  enable = true;
  signing.format = null;
  settings = {
    user.name = "Christos";
    user.email = "christosm-dev@users.noreply.github.com";
    init.defaultBranch = "main";
    pull.rebase = true;
    push.autoSetupRemote = true;
    core.editor = "nvim";
  };
  ignores = [
    ".DS_Store"
    "*.swp"
    ".direnv"
    ".env"
  ];};

  home.packages = with pkgs; [
    curl
    wget
    ripgrep
    fd
    bat
    eza
    fzf
    jq
  ];

  programs.home-manager.enable = true;
}
