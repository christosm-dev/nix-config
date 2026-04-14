{ pkgs, ... }: {

programs.bash.initExtra = ''
  # Nix PATH fix for multi-user install on WSL2
  export PATH="$HOME/.nix-profile/bin:$PATH"
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
'';

  # WSL2-specific Neovim overrides
  programs.neovim.initLua = ''
    vim.opt.fileformats = { "unix", "dos" }
    vim.opt.fileformat = "unix"

    -- Strip carriage returns from Windows clipboard paste
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function()
        vim.cmd([[silent! %s/\r//g]])
      end
    })
  '';
}
