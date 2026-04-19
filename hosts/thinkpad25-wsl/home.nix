# hosts/thinkpad25-wsl/home.nix
# WSL2-specific overrides for thinkpad25.
# Applied on top of modules/common.nix and modules/neovim.nix.
#
# WSL2 quirks addressed here:
# 1. Nix multi-user install on WSL2 does not automatically add
#    ~/.nix-profile/bin to PATH — added manually via bash initExtra.
# 2. Windows clipboard injects CRLF line endings when pasting into
#    Neovim — stripped automatically via BufReadPost autocmd.
{ pkgs, ... }: {

  home.username = "xmixa";
  home.homeDirectory = "/home/xmixa";

  # Keep this at the version when Home Manager was first installed.
  # Changing it may trigger breaking changes in module defaults.
  home.stateVersion = "23.11";

  # Bash — WSL2-specific shell initialisation
  # Adds Nix profile to PATH and sources Home Manager session variables.
  # This is required because the standard Nix shell integration script
  # (/etc/profile.d/nix.sh) is not present in WSL2 multi-user installs.
  programs.bash.initExtra = ''
    export PATH="$HOME/.nix-profile/bin:$PATH"
    source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  '';

  # Neovim — WSL2-specific overrides
  # Strips carriage returns (\r) inserted by the Windows clipboard
  # when pasting text copied from Windows applications into Neovim.
  # Forces unix line endings on all new buffers.
  programs.neovim.initLua = ''
    vim.opt.fileformats = { "unix", "dos" }
    vim.opt.fileformat = "unix"

    -- Strip carriage returns on buffer load (Windows clipboard CRLF fix)
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function()
        vim.cmd([[silent! %s/\r//g]])
      end
    })
  '';
}
