---@diagnostic disable: undefined-global

-- lazy.nvim を自動で導入する
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("lazy.nvim の取得に失敗しました:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 基本設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.mouse = "a"
vim.opt.termguicolors = true

-- タブラインの切り替え (.vimrc の airline の <C-p>/<C-n> 相当)
vim.keymap.set("n", "<C-p>", "<cmd>tabprevious<CR>", { silent = true, desc = "前のタブへ" })
vim.keymap.set("n", "<C-n>", "<cmd>tabnext<CR>", { silent = true, desc = "次のタブへ" })

-- ファイラー (oil.nvim)
vim.keymap.set("n", "<leader>e", function()
  require("oil").open()
end, { silent = true, desc = "ファイラーを開く" })
vim.keymap.set("n", "<leader>f", function()
  require("oil").open(vim.fn.expand("%:p:h"))
end, { silent = true, desc = "現在のファイルのあるディレクトリを開く" })

-- LSP の警告・エラーを表示する
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

require("lazy").setup({
  -- カラーテーマ (dracula/vim の代替)
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("dracula")
    end,
  },

  -- ファイラー (vim-fern の代替)
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    opts = {
      -- ディレクトリを開いたとき netrw の代わりに oil を使う
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        -- fern の操作に合わせる
        ["v"] = "actions.select_vsplit",
        ["s"] = "actions.select_split",
      },
    },
  },

  -- ステータスバー / タブライン (vim-airline の代替)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "dracula",
        icons_enabled = true,
      },
      tabline = {
        lualine_a = { { "buffers", mode = 2 } },
      },
    },
  },

  -- コメントアウト (vim-commentary の代替。gc / gcc で同じ操作)
  { "echasnovski/mini.comment", opts = {} },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local filetypes = { "go", "gomod", "gowork", "gosum" }

      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      require("nvim-treesitter").install(filetypes)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
          -- パーサーのインストール完了前でも起動時に落ちないようにする
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- LSP: サーバーのインストールに mason、クライアントにはNeovim標準の vim.lsp を使用
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls" },
        -- 手動設定した gopls を使うため、自動設定は無効にする
        automatic_enable = false,
      })

      vim.lsp.config("gopls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable("gopls")
    end,
  },

  -- 自動補完 (asyncomplete の代替)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },
})
