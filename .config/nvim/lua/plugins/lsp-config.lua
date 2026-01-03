return {
  {
    -- Mason for managing LSP servers
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    -- Mason LSP config integration
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true, -- Automatically install LSP servers that are needed
    },
  },
  {
    -- nvim-lspconfig for configuring LSP servers
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Default capabilities for nvim-cmp

      local lspconfig = require("lspconfig")

      -- Setup for TypeScript (ts_ls)
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        -- Additional ts_ls-specific options can go here
      })

      -- Setup for Solargraph (Ruby)
      lspconfig.solargraph.setup({
        capabilities = capabilities
      })

      -- Setup for HTML (html)
      lspconfig.html.setup({
        capabilities = capabilities
      })

      -- Setup for CSS (cssls)
      lspconfig.cssls.setup({
        capabilities = capabilities
      })

      -- Setup for JavaScript (ts_ls, since it also covers JS)
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        -- Additional js-specific options can go here
      })

      -- Setup for Lua (lua_ls)
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      -- Keybindings for LSP functions
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

