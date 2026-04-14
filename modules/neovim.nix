{ pkgs, ... }: {

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    initLua = ''
      -- Indentation
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end
      })

      -- LSP servers
      vim.lsp.config("nil_ls",      { cmd = { "nil" },                           filetypes = { "nix" }, root_markers = { "flake.nix", ".git" } })
      vim.lsp.config("pyright",     { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" } })
      vim.lsp.config("terraformls", { cmd = { "terraform-ls", "serve" },         filetypes = { "terraform", "tf" } })
      vim.lsp.config("bashls",      { cmd = { "bash-language-server", "start" }, filetypes = { "sh", "bash" } })
      vim.lsp.config("lua_ls",      { cmd = { "lua-language-server" },           filetypes = { "lua" } })
      vim.lsp.config("dockerls",    { cmd = { "docker-langserver", "--stdio" },  filetypes = { "dockerfile" } })

      vim.lsp.enable({
        "nil_ls", "pyright", "terraformls", "bashls", "lua_ls", "dockerls",
      })

    '';
  };

  home.packages = with pkgs; [
    nil
    pyright
    terraform-ls
    bash-language-server
    lua-language-server
    dockerfile-language-server
  ];
}
