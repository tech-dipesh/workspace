-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/snacks.lua — Extends LazyVim's snacks.nvim     ║
-- ╚══════════════════════════════════════════════════════════╝
-- IMPORTANT: We EXTEND snacks.nvim opts here.
-- LazyVim already provides snacks — we only add/change opts.

return {
  {
    "folke/snacks.nvim",
    opts = {
      -- ── Keep your original settings ─────────────────────
      image = {
        enabled      = true,
        force_magick = true,
        doc          = { inline = true },
      },
      picker    = { enabled = true },
      terminal  = { enabled = true },
      notifier  = { enabled = true },
      quickfile = { enabled = true },
      scope     = { enabled = true },
      scroll    = { enabled = true },
      words     = { enabled = true },

      -- ── Snacks explorer disabled (we use neo-tree) ────────
      explorer = { enabled = false },

      -- ── Dashboard ─────────────────────────────────────────
      -- Shows recent git commits + project list on start screen
      dashboard = {
        enabled = true,
        preset  = {
          header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    YouTuber Pro  |  JS/TS + C++  |  Windows 11    ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File",    action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "g", desc = "Find Text",    action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "p", desc = "Projects",     action = ":lua Snacks.dashboard.pick('projects')" },
            { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
            { icon = " ", key = "c", desc = "Config",       action = ":e $MYVIMRC" },
            { icon = " ", key = "l", desc = "Lazy",         action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys",  gap = 1, padding = 1 },
          -- Recent projects (right pane)
          { pane = 2, section = "projects", padding = 1 },
          -- Last 8 git commits (right pane)
          {
            pane    = 2,
            icon    = " ",
            title   = "Recent Commits",
            section = "terminal",
            enabled = vim.fn.executable("git") == 1,
            cmd     = "git --no-pager log --oneline --decorate --abbrev-commit --color=always -8 2>NUL || echo Not a git repo",
            height  = 8,
            padding = 1,
            ttl     = 300,
            indent  = 3,
          },
          { section = "startup" },
        },
      },

      -- ── Notifier: compact, bottom-right ───────────────────
      notifier = {
        enabled  = true,
        timeout  = 3000,
        width    = { min = 35, max = 0.38 },
        height   = { min = 1,  max = 0.6 },
        margin   = { top = 0, right = 1, bottom = 1 },
        padding  = true,
        sort     = { "level", "added" },
        icons    = {
          error  = " ",
          warn   = " ",
          info   = " ",
          debug  = " ",
          trace  = "✎ ",
        },
        style    = "compact",
        top_down = false,
      },

      -- ── Status column ──────────────────────────────────────
      statuscolumn = {
        enabled = true,
        left    = { "mark", "sign" },
        right   = { "fold", "git" },
        folds   = { open = false, git_hl = true },
        git     = { patterns = { "GitSign", "MiniDiffSign" } },
        refresh = 50,
      },

      -- ── Indent animation ──────────────────────────────────
      indent = {
        enabled  = true,
        indent   = { char = "|", hl = "SnacksIndent" },
        scope    = { char = "|", hl = "SnacksIndentScope" },
        animate  = {
          enabled  = true,
          easing   = "linear",
          duration = { step = 20, total = 500 },
        },
      },

      -- ── LazyGit integration ────────────────────────────────
      lazygit = {
        enabled   = true,
        configure = true,
        config = {
          os  = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
        win = { border = "rounded", width = 0, height = 0 },
      },

      -- ── Git browse (open in GitHub) ────────────────────────
      gitbrowse = { enabled = true },
    },
  },
}
