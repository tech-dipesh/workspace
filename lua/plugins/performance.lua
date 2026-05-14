-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/performance.lua — Lazy loading overrides       ║
-- ║                                                          ║
-- ║  LazyVim loads most things eagerly. For a JS/TS + C++   ║
-- ║  workflow we only need certain things immediately.       ║
-- ║  Everything else is deferred until actually needed.      ║
-- ║                                                          ║
-- ║  Strategy:                                               ║
-- ║  • Startup critical: colorscheme, options, keymaps      ║
-- ║  • Load on filetype: LSP servers, formatters, linters   ║
-- ║  • Load on command: Git UI, debugger, REST client       ║
-- ║  • Load on key: Telescope, neo-tree, harpoon            ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── Make heavy plugins truly lazy ────────────────────────

  -- Neogit: only when you run :Neogit or press <leader>gg
  { "NeogitOrg/neogit",     lazy = true, cmd = "Neogit" },

  -- Diffview: only when you open a diff
  { "sindrets/diffview.nvim", lazy = true,
    cmd = { "DiffviewOpen","DiffviewFileHistory","DiffviewClose" } },

  -- Octo (GitHub): only when you run :Octo
  { "pwntester/octo.nvim",  lazy = true, cmd = "Octo" },

  -- git-worktree: only on keymap
  { "ThePrimeagen/git-worktree.nvim", lazy = true,
    keys = { "<leader>gwl", "<leader>gwc" } },

  -- Spectre: only on keymap
  { "nvim-pack/nvim-spectre", lazy = true,
    cmd = "Spectre",
    keys = { "<leader>sr", "<leader>sw" } },

  -- undotree: only on keymap
  { "mbbill/undotree", lazy = true, cmd = "UndotreeToggle" },

  -- inc-rename: only on keymap
  { "smjonas/inc-rename.nvim", lazy = true, cmd = "IncRename" },

  -- markdown-preview: only for markdown files
  { "iamcco/markdown-preview.nvim",
    lazy = true,
    ft   = { "markdown" },
    cmd  = { "MarkdownPreview","MarkdownPreviewStop" } },

  -- render-markdown: only for markdown files
  { "MeanderingProgrammer/render-markdown.nvim",
    lazy = true, ft = { "markdown" } },

  -- package-info: only for package.json
  { "vuki656/package-info.nvim",
    lazy = true, ft = { "json" } },

  -- live-server: only for HTML
  { "selimacerbas/live-server.nvim",
    lazy = true, ft = { "html" },
    cmd  = { "LiveServerStart","LiveServerStop","LiveServerOpen" } },

  -- DAP debugger: only for C/C++ files
  { "mfussenegger/nvim-dap",
    lazy = true, ft = { "c","cpp" } },
  { "rcarriga/nvim-dap-ui",
    lazy = true, ft = { "c","cpp" } },
  { "theHamsta/nvim-dap-virtual-text",
    lazy = true, ft = { "c","cpp" } },

  -- clangd_extensions: only for C/C++ files
  { "p00f/clangd_extensions.nvim",
    lazy = true, ft = { "c","cpp" } },

  -- Screenkey: only when toggled
  { "NStefan002/screenkey.nvim",
    lazy = true, cmd = "Screenkey" },

  -- SchemaStore: only when LSP needs it
  { "b0o/SchemaStore.nvim", lazy = true },

  -- neodev: only for Lua files
  { "folke/neodev.nvim", lazy = true, ft = { "lua" } },

  -- Telescope file-browser: lazy extension
  { "nvim-telescope/telescope-file-browser.nvim", lazy = true },

  -- mini.splitjoin: only after a file is open
  { "nvim-mini/mini.splitjoin", lazy = true, event = "BufReadPost" },

  -- ── Startup time: disable features that slow down initial load ──

  -- Disable LazyVim's animate on large files (already handled in autocmds)
  -- This is a noop spec but signals our intent
  {
    "nvim-mini/mini.animate",
    -- Disable animation for large files
    opts = function(_, opts)
      opts.scroll = vim.tbl_extend("force", opts.scroll or {}, {
        predicate = function()
          -- Don't animate in large files
          return not vim.b.large_file
        end,
      })
      return opts
    end,
  },

  -- ── vim.loader: byte-compile Lua for faster require() ────
  -- This is Neovim 0.9+ feature — enables automatically.
  -- We just make sure it's on.
  {
    "folke/lazy.nvim",
    init = function()
      if vim.fn.has("nvim-0.9") == 1 then
        vim.loader.enable()
      end
    end,
  },
}
