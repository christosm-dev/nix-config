# modules/neovim.nix
# Neovim configuration applied to all hosts.
# Uses native Neovim 0.11+ LSP API (vim.lsp.config) instead of nvim-lspconfig.
# LSP servers are installed via home.packages and configured with explicit
# filetypes to prevent servers attaching to incorrect buffers.
{ pkgs, ... }: {

  programs.neovim = {
    enable = true;
    defaultEditor = true;  # sets EDITOR=nvim
    vimAlias = true;       # allows calling nvim with 'vim'
    withRuby = false;      # disabled - not needed for current workflow
    withPython3 = false;   # disabled - not needed for current workflow

    initLua = ''
      -- Indentation
      -- All values set consistently to avoid mixed tab/space behaviour
      vim.opt.tabstop = 2       -- tab character displays as 2 spaces
      vim.opt.shiftwidth = 2    -- indent/dedent steps of 2 spaces
      vim.opt.softtabstop = 2   -- tab key inserts 2 spaces
      vim.opt.expandtab = true  -- always insert spaces, never tab characters
      vim.opt.smartindent = true

      -- Show diagnostics automatically after cursor is stationary
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end
      })
      vim.opt.updatetime = 500  -- ms before CursorHold triggers

      -- LSP keymaps
      -- Set when an LSP server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd",          vim.lsp.buf.definition,   opts)   -- go to definition
          vim.keymap.set("n", "K",            vim.lsp.buf.hover,        opts)  -- hover docs
          vim.keymap.set("n", "gr",           vim.lsp.buf.references,   opts)  -- find references
          vim.keymap.set("n", "<leader>rn",   vim.lsp.buf.rename,       opts)  -- rename symbol
          vim.keymap.set("n", "<leader>ca",   vim.lsp.buf.code_action,  opts)  -- code action
          vim.keymap.set("n", "[d",           vim.diagnostic.goto_prev, opts)  -- prev diagnostic
          vim.keymap.set("n", "]d",           vim.diagnostic.goto_next, opts)  -- next diagnostic
        end
      })

      -- LSP server configuration
      -- Explicit filetypes prevent servers attaching to incorrect buffers.
      -- root_markers enables project-aware analysis for multi-file context.
      -- Note: vim.lsp.config is the native API introduced in Neovim 0.11+,
      -- replacing the deprecated nvim-lspconfig require('lspconfig') approach.
      vim.lsp.config("nil_ls", {
        cmd = { "nil" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },  -- project root detection
      })
      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", ".git" },
      })
      vim.lsp.config("terraformls", {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "tf" },
        root_markers = { ".terraform", ".git" },
      })
      vim.lsp.config("bashls", {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
      })
      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
      })
      vim.lsp.config("dockerls", {
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { ".git" },
      })

      vim.lsp.enable({
        "nil_ls",
        "pyright",
        "terraformls",
        "bashls",
        "lua_ls",
        "dockerls",
      })
    '';
  };

  # LSP server binaries
  # These are referenced by the vim.lsp.config cmd fields above
  home.packages = with pkgs; [
    nil                        # Nix language server
    pyright                    # Python language server
    terraform-ls               # Terraform language server
    bash-language-server       # Bash language server
    lua-language-server        # Lua language server
    dockerfile-language-server # Dockerfile language server
  ];
}
