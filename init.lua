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

-- Use indent-based folding for filetypes with limited treesitter fold support
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})

-------------------------------------------------------------------------------
-- General mappings
-------------------------------------------------------------------------------
vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", { silent = true })

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
        "markdown", "markdown_inline",
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
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })

      -- Quit nvim when nvim-tree is the only remaining window
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function()
          vim.schedule(function()
            local wins = vim.api.nvim_list_wins()
            local non_floating = {}
            for _, w in ipairs(wins) do
              if vim.api.nvim_win_get_config(w).relative == "" then
                table.insert(non_floating, w)
              end
            end
            if #non_floating == 1 then
              local buf = vim.api.nvim_win_get_buf(non_floating[1])
              if vim.bo[buf].filetype == "NvimTree" then
                vim.cmd("quit")
              end
            end
          end)
        end,
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

  -- Snacks (picker, dashboard, notifier, lazygit, terminal, and more) ----------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker   = { enabled = true },
      dashboard = { enabled = true },
      notifier  = { enabled = true },
      lazygit   = { enabled = true },
      terminal  = { enabled = true },
      indent    = { enabled = true },
      scroll    = { enabled = true },
      words     = { enabled = true },   -- highlight word under cursor
      bufdelete = { enabled = true },
      zen       = { enabled = true },
    },
    keys = {
      -- Picker: replaces telescope (same shortcuts as before)
      { "<C-f>",      function() Snacks.picker.git_files() end,  desc = "Git files" },
      { "<C-p>",      function() Snacks.picker.files() end,       desc = "Find files" },
      { "<Leader>f",  function() Snacks.picker.grep() end,        desc = "Live grep" },
      { "<Leader>F",  function() Snacks.picker.grep_word() end,   desc = "Grep word under cursor" },
      -- Picker: extra pickers
      { "<Leader>sb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
      { "<Leader>sc", function() Snacks.picker.commands() end,    desc = "Commands" },
      { "<Leader>sk", function() Snacks.picker.keymaps() end,     desc = "Keymaps" },
      { "<Leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<Leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<Leader>sr", function() Snacks.picker.resume() end,      desc = "Resume last picker" },
      -- Lazygit
      { "<Leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit" },
      -- Floating terminal
      { "<Leader>tt", function() Snacks.terminal() end,           desc = "Toggle terminal" },
      -- Zoom toggle (replaces :only)
      { "<C-w>o",     function() Snacks.zen() end,                desc = "Toggle zoom (zen)" },
    },
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
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<Leader>gd", ":DiffviewOpen<CR>",        silent = true, desc = "Diff view (working tree)" },
      { "<Leader>gh", ":DiffviewFileHistory %<CR>", silent = true, desc = "File git history" },
    },
    config = true,
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

  -- Highlight current search match ------------------------------------------
  {
    "rktjmp/highlight-current-n.nvim",
    keys = {
      { "n", "<Plug>(highlight-current-n-n)", desc = "Next search match" },
      { "N", "<Plug>(highlight-current-n-N)", desc = "Prev search match" },
    },
    config = function()
      require("highlight_current_n").setup()
    end,
  },

  -- Surround ------------------------------------------------------------------
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        surrounds = {
          ["C"] = {
            add = function()
              local lang = vim.fn.input("Language: ")
              return { { "```" .. lang }, { "```" } }
            end,
          },
        },
      })
    end,
  },

  -- Render Markdown -----------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = true,
  },

  -- Which-key -----------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
})
