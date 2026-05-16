-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/git.lua — Heavy Git + GitHub features          ║
-- ║  gitsigns | neogit | diffview | octo PRs | worktrees    ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── gitsigns: extend LazyVim's config ────────────────────
  -- LazyVim ships gitsigns. We add inline blame + more keys.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "|" },
        change       = { text = "|" },
        delete       = { text = "_" },
        topdelete    = { text = "^" },
        changedelete = { text = "~" },
        untracked    = { text = "|" },
      },
      -- Inline blame (like GitLens in VS Code)
      current_line_blame = true,
      current_line_blame_opts = {
        delay        = 700,
        virt_text_pos = "eol",
      },
      current_line_blame_formatter =
        " <author>  <author_time:%Y-%m-%d>  <summary>",
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs,
            { buffer = bufnr, silent = true, desc = desc })
        end

        -- Navigate hunks
        map("n", "]h", function()
          if vim.wo.diff then return "]c" end
          gs.next_hunk()
        end, "Git: Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then return "[c" end
          gs.prev_hunk()
        end, "Git: Prev hunk")

        -- Stage / reset
        map({ "n","v" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>",  "Git: Stage hunk")
        map({ "n","v" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>",  "Git: Reset hunk")
        map("n",         "<leader>ghS", gs.stage_buffer,             "Git: Stage buffer")
        map("n",         "<leader>ghR", gs.reset_buffer,             "Git: Reset buffer")
        map("n",         "<leader>ghu", gs.undo_stage_hunk,          "Git: Undo stage")

        -- Preview / diff
        map("n", "<leader>ghp", gs.preview_hunk,                            "Git: Preview hunk")
        map("n", "<leader>ghd", gs.diffthis,                                "Git: Diff vs HEAD")
        map("n", "<leader>ghD", function() gs.diffthis("~") end,            "Git: Diff vs parent")
        map("n", "<leader>ghb", function() gs.blame_line({ full=true }) end, "Git: Full blame")

        -- Toggles
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Git: Toggle inline blame")
        map("n", "<leader>gtd", gs.toggle_deleted,            "Git: Toggle deleted lines")

        -- Text objects
        map({ "o","x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Git: Select hunk")
      end,
    },
  },

  -- ── Neogit: full-screen Git TUI ───────────────────────────
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd  = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>",             desc = "Git: Neogit (status)" },
      { "<leader>gC", "<cmd>Neogit commit<cr>",      desc = "Git: Commit" },
      { "<leader>gP", "<cmd>Neogit push<cr>",        desc = "Git: Push" },
      { "<leader>gF", "<cmd>Neogit pull<cr>",        desc = "Git: Pull" },
      { "<leader>gm", "<cmd>Neogit merge<cr>",       desc = "Git: Merge" },
      { "<leader>gR", "<cmd>Neogit rebase<cr>",      desc = "Git: Rebase" },
    },
    opts = {
      graph_style  = "unicode",
      integrations = { telescope = true, diffview = true },
      signs = {
        hunk    = { "", "" },
        item    = { ">", "v" },
        section = { ">", "v" },
      },
    },
  },

  -- ── Diffview: beautiful diff viewer ───────────────────────
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd  = { "DiffviewOpen","DiffviewFileHistory","DiffviewClose" },
    keys = {
      { "<leader>gd",  "<cmd>DiffviewOpen<cr>",           desc = "Git: Diff view" },
      { "<leader>gD",  "<cmd>DiffviewOpen HEAD~1<cr>",    desc = "Git: Diff vs last commit" },
      { "<leader>gf",  "<cmd>DiffviewFileHistory %<cr>",  desc = "Git: File history" },
      { "<leader>gA",  "<cmd>DiffviewFileHistory<cr>",    desc = "Git: All history" },
      { "<leader>gX",  "<cmd>DiffviewClose<cr>",          desc = "Git: Close diffview" },
      { "<leader>gc",  function()
          local b = vim.fn.input("Compare with branch: ")
          if b ~= "" then vim.cmd("DiffviewOpen " .. b) end
        end, desc = "Git: Diff vs branch" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default      = { layout = "diff2_horizontal", winbar_info = true },
        file_history = { layout = "diff2_horizontal" },
        merge_tool   = { layout = "diff3_horizontal", disable_diagnostics = true },
      },
    },
  },

  -- ── Octo: GitHub PRs + Issues inside Neovim ──────────────
  -- Requires: gh auth login  (run in terminal first)
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd  = "Octo",
    keys = {
      -- Pull Requests
      { "<leader>Gpl", "<cmd>Octo pr list<cr>",           desc = "GitHub: List PRs" },
      { "<leader>Gps", "<cmd>Octo pr search<cr>",         desc = "GitHub: Search PRs" },
      { "<leader>Gpc", "<cmd>Octo pr create<cr>",         desc = "GitHub: Create PR" },
      { "<leader>Gpv", "<cmd>Octo pr browser<cr>",        desc = "GitHub: View PR in browser" },
      { "<leader>Gpd", "<cmd>Octo pr diff<cr>",           desc = "GitHub: PR diff" },
      { "<leader>Gpm", "<cmd>Octo pr merge squash<cr>",   desc = "GitHub: Merge PR (squash)" },
      { "<leader>GpM", "<cmd>Octo pr merge commit<cr>",   desc = "GitHub: Merge PR (commit)" },
      { "<leader>Gpa", function()
          local r = vim.fn.input("Reviewer: ")
          if r ~= "" then vim.cmd("Octo pr add_reviewer " .. r) end
        end, desc = "GitHub: Add PR reviewer" },
      -- Reviews
      { "<leader>Grv", "<cmd>Octo review start<cr>",      desc = "GitHub: Start review" },
      { "<leader>GrS", "<cmd>Octo review submit<cr>",     desc = "GitHub: Submit review" },
      { "<leader>Grc", "<cmd>Octo review comments<cr>",   desc = "GitHub: Review comments" },
      -- Issues
      { "<leader>Gil", "<cmd>Octo issue list<cr>",        desc = "GitHub: List issues" },
      { "<leader>Gic", "<cmd>Octo issue create<cr>",      desc = "GitHub: Create issue" },
      { "<leader>Gib", "<cmd>Octo issue browser<cr>",     desc = "GitHub: Issue in browser" },
      -- Comments
      { "<leader>Gca", "<cmd>Octo comment add<cr>",       desc = "GitHub: Add comment" },
      { "<leader>Gla", "<cmd>Octo label add<cr>",         desc = "GitHub: Add label" },
      { "<leader>Gaa", "<cmd>Octo assignee add<cr>",      desc = "GitHub: Assign user" },
    },
    opts = {
      default_remote  = { "upstream", "origin" },
      ui = {
        use_signcolumn = true,
      },
      file_panel = { size = 10, use_icons = true },
    },
  },

  -- ── git-worktree: parallel branches ──────────────────────
  -- Use case: work on feature/x and main at the same time
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("git-worktree").setup({
        change_directory_command = "cd",
        update_on_change         = true,
        update_on_change_command = "e .",
        clearjumps_on_change     = true,
        autopush                 = false,
      })
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      { "<leader>gwl", function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end, desc = "Worktree: list / switch" },
      { "<leader>gwc", function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end, desc = "Worktree: create" },
    },
  },

  -- ── LazyGit: full UI via snacks ───────────────────────────
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gG", function() Snacks.lazygit() end,      desc = "Git: LazyGit" },
      { "<leader>gB", function() Snacks.gitbrowse() end,    desc = "Git: Browse on GitHub" },
      { "<leader>gfl", function() Snacks.lazygit.log() end, desc = "Git: LazyGit file log" },
    },
  },
}
