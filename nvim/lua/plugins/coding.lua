-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/coding.lua — Formatting, pairs, utilities      ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── conform.nvim: extend LazyVim's formatter config ──────
  -- LazyVim ships conform. We add our formatters on top.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript       = { "prettierd", "prettier" },
        javascriptreact  = { "prettierd", "prettier" },
        typescript       = { "prettierd", "prettier" },
        typescriptreact  = { "prettierd", "prettier" },
        json             = { "prettierd", "prettier" },
        jsonc            = { "prettierd", "prettier" },
        html             = { "prettierd", "prettier" },
        css              = { "prettierd", "prettier" },
        scss             = { "prettierd", "prettier" },
        markdown         = { "prettierd", "prettier" },
        yaml             = { "prettierd", "prettier" },
        lua              = { "stylua" },
        cpp              = { "clang_format" },
        c                = { "clang_format" },
      },
      -- Auto-format on save (respects vim.g.autoformat toggle)
      format_on_save = function(bufnr)
        if not vim.g.autoformat then return end
        if vim.b[bufnr].large_file  then return end  -- skip large files
        return { timeout_ms = 1500, lsp_fallback = true }
      end,
      formatters = {
        clang_format = { prepend_args = { "--style=Google" } },
      },
    },
  },

  -- ── autopairs: extend LazyVim's config ───────────────────
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts    = true,
      ts_config   = {
        lua        = { "string" },
        javascript = { "template_string" },
        typescript = { "template_string" },
      },
      -- Fast-wrap: <M-e> wraps selection in brackets
      fast_wrap = {
        map     = "<M-e>",
        chars   = { "{","[","(","\"","'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        keys    = "qwertyuiopzxcvbnmasdfghjkl",
      },
    },
  },

  -- ── package-info: npm version hints in package.json ──────
  {
    "vuki656/package-info.nvim",
    ft           = "json",
    dependencies = "MunifTanjim/nui.nvim",
    keys = {
      { "<leader>ns", function() require("package-info").show()           end, ft="json", desc = "npm: Show versions" },
      { "<leader>nh", function() require("package-info").hide()           end, ft="json", desc = "npm: Hide versions" },
      { "<leader>nu", function() require("package-info").update()         end, ft="json", desc = "npm: Update package" },
      { "<leader>ni", function() require("package-info").install()        end, ft="json", desc = "npm: Install package" },
      { "<leader>np", function() require("package-info").change_version() end, ft="json", desc = "npm: Change version" },
      { "<leader>nd", function() require("package-info").delete()         end, ft="json", desc = "npm: Delete package" },
    },
    opts = {
      colors = {
        up_to_date = "#3C4048",
        outdated   = "#d19a66",
      },
      autostart = false,
    },
  },

  -- ── mini.splitjoin: split/join args with gS ──────────────
  -- gS on function call: split args to multiple lines or join back
  {
  "nvim-mini/mini.splitjoin",
    version = false,
    event   = "BufReadPost",
    opts    = { mappings = { toggle = "gS" } },
  },

  -- ── undotree: visual undo history ────────────────────────
  {
    "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
  },

  -- ── inc-rename: LSP rename with live preview ─────────────
  {
    "smjonas/inc-rename.nvim",
    cmd  = "IncRename",
    keys = {
      { "<leader>cr", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end, desc = "LSP: Rename (live preview)", expr = true },
    },
    opts = {},
  },

  -- ── todo-comments: extend LazyVim's config ───────────────
  {
    "folke/todo-comments.nvim",
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    },
    opts = {
      signs    = true,
      keywords = {
        FIX    = { icon = " ", color = "error",   alt = { "FIXME","BUG","FIXIT" } },
        TODO   = { icon = " ", color = "info"   },
        HACK   = { icon = " ", color = "warning" },
        WARN   = { icon = " ", color = "warning", alt = { "WARNING","XXX" } },
        PERF   = { icon = " ", color = "default", alt = { "OPTIM","PERFORMANCE" } },
        NOTE   = { icon = " ", color = "hint",    alt = { "INFO" } },
        TEST   = { icon = " ", color = "test",    alt = { "TESTING","PASSED","FAILED" } },
        DEBUG  = { icon = " ", color = "error" },
        REVIEW = { icon = " ", color = "warning" },
      },
    },
  },
}
