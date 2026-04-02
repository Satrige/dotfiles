-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (must be set before lazy)
vim.g.mapleader = "\\"

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.number = true
vim.opt.colorcolumn = "120"
vim.opt.signcolumn = "yes"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-------------------------------------------------------------------------------
-- Clipboard mappings (preserved from old config)
-------------------------------------------------------------------------------
vim.keymap.set("v", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>Y", '"+yg_')
vim.keymap.set("n", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>yy", '"+yy')
vim.keymap.set("n", "<Leader>p", '"+p')
vim.keymap.set("n", "<Leader>P", '"+P')
vim.keymap.set("v", "<Leader>p", '"+p')
vim.keymap.set("v", "<Leader>P", '"+P')

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup({

  -- Colorscheme ---------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Treesitter ----------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "rust", "javascript", "typescript", "python",
        "lua", "yaml", "go", "json", "bash", "dockerfile",
      },
    },
  },

  -- LSP -----------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "rust_analyzer",
          "ts_ls",
          "gopls",
          "pyright",
          "lua_ls",
          "jsonls",
          "yamlls",
          "bashls",
          "dockerls",
        },
      })

      -- Default capabilities for all servers (nvim 0.11+ API)
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        vim.lsp.config("*", {
          capabilities = cmp_lsp.default_capabilities(),
        })
      end

      -- Server-specific config
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- Enable all servers
      vim.lsp.enable({
        "rust_analyzer", "ts_ls", "gopls", "pyright",
        "lua_ls", "jsonls", "yamlls", "bashls", "dockerls",
      })

      -- LSP keybindings (activated when an LSP server attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = { buffer = args.buf }
          vim.keymap.set("n", "<Leader>d", function()
            vim.cmd("tab split")
            vim.lsp.buf.definition()
          end, buf)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, buf)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, buf)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf)
          vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, buf)
          vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, buf)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf)
          vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, buf)
        end,
      })
    end,
  },

  -- Autocompletion ------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- File explorer -------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        filters = { dotfiles = false },
        view = { width = 30 },
      })

      -- Auto-open when launching nvim with a directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end,
      })

      vim.keymap.set("n", "<Leader>nf", ":NvimTreeFindFile<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>nt", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- Fuzzy finder (telescope) --------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-f>", builtin.git_files)      -- was: fzf git ls-files
      vim.keymap.set("n", "<C-p>", builtin.find_files)      -- was: :Files
      vim.keymap.set("n", "<Leader>f", builtin.live_grep)   -- was: :Rg
      vim.keymap.set("n", "<Leader>F", builtin.grep_string) -- was: :Rg <cword>
    end,
  },

  -- Statusline ----------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
      })
    end,
  },

  -- Git -----------------------------------------------------------------------
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Comments ------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local api = require("Comment.api")
      vim.keymap.set("n", "<C-\\>", api.toggle.linewise.current)
      vim.keymap.set("v", "<C-\\>",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
    end,
  },

  -- Autopairs -----------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Which-key -----------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
})
