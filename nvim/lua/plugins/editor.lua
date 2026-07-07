-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/editor.lua — File explorer, search, navigation ║
-- ║  • neo-tree: shows hidden files, file counts, project root locked
-- ║  • Telescope: always searches from project root          ║
-- ║  • which-key: group labels for <leader>                 ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── neo-tree: file explorer ───────────────────────────────
  -- LazyVim provides neo-tree. We extend its opts here.
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      popup_border_style   = "rounded",
      enable_git_status    = true,
      enable_diagnostics   = true,

      -- Source tabs at top: Files | Git | Buffers
      sources = { "filesystem", "git_status", "buffers" },
      source_selector = {
        winbar   = true,
        statusline = false,
        sources  = {
          { source = "filesystem", display_name = " Files" },
          { source = "git_status", display_name = " Git"  },
          { source = "buffers",    display_name = " Bufs"  },
        },
      },

      default_component_configs = {
        indent = {
          indent_size        = 2,
          with_markers       = true,
          indent_marker      = "|",
          last_indent_marker = "L",
          with_expanders     = true,
          expander_collapsed = "",
          expander_expanded  = "",
        },
        icon = {
          folder_closed = "",
          folder_open   = "",
          folder_empty  = "",
          default       = "",
        },
        git_status = {
          symbols = {
            added     = "+",
            modified  = "~",
            deleted   = "-",
            renamed   = ">",
            untracked = "?",
            ignored   = ".",
            unstaged  = "!",
            staged    = "S",
            conflict  = "C",
          },
        },
        diagnostics = {
          symbols = {
            error = " ",
            warn  = " ",
            hint  = " ",
            info  = " ",
          },
        },
      },

      filesystem = {
        -- ── PROJECT ROOT LOCKING ───────────────────────────
        -- bind_to_cwd = false means the tree root does NOT
        -- change when you open a file in a sub-directory.
        -- This matches VS Code's "Explorer never changes root" behaviour.
        bind_to_cwd  = false,
        cwd_target   = { sidebar = "tab", current = "window" },

        follow_current_file = {
          enabled        = true,   -- highlight file in tree when buffer changes
          leave_dirs_open = false,  -- keep parent dirs expanded
        },

        group_empty_dirs = true,

        -- Don't close tree automatically (VS Code behaviour)
        hijack_netrw_behavior = "open_current",

        -- ── HIDDEN FILES: show by default ─────────────────
        -- We show all dotfiles EXCEPT .git internals.
        -- Press H to toggle node_modules visibility.
        filtered_items = {
          visible           = true,   -- show hidden items (not just dimmed)
          show_hidden_count = true,   -- show count badge: "node_modules (847)"

          hide_dotfiles    = false,   -- SHOW: .env, .gitignore, etc.
	  respect_gitignore = false,
          hide_gitignored  = false,   -- SHOW: gitignored files
          hide_hidden      = false,   -- SHOW: Windows hidden-attribute files

          -- Only hide these specific names
          hide_by_name = {
            ".git",             -- .git internals are never useful to browse
            ".DS_Store",
            "thumbs.db",
            "NUL"
          },
	always_show_by_pattern = { "%.md$" },

          -- Always visible regardless of other rules
          always_show = {
            ".env.local",
            ".env.development",
            ".env.production",
            ".env.test",
            ".gitignore",
            ".gitattributes",
            ".dockerignore",
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
            ".eslintignore",
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.json",
            ".prettierignore",
            ".nvmrc",
            ".npmrc",
            ".vscode",
            ".editorconfig",
            ".babelrc",
	    "*.md",
          },

          -- Never show these (even if always_show matches)
          never_show           = { ".git", "NUL" },

          never_show_by_pattern = { "^%.git$" },
        },

        use_libuv_file_watcher = true,   -- live-reload when files change on disk

        window = {
          mappings = {
            ["H"]    = "toggle_hidden",         -- toggle node_modules
            ["Y"]    = function(state)           -- copy path to clipboard
              local path = state.tree:get_node().path
              vim.fn.setreg("+", path)
              vim.notify("Copied: " .. path, vim.log.levels.INFO, { timeout = 1200 })
            end,
            -- Vim-like navigation
            ["l"]    = "open",
            ["h"]    = "close_node",
            ["P"]    = { "toggle_preview", config = { use_float = true } },
            -- Split / tab
            ["<C-x>"] = "open_split",
            ["<C-v>"] = "open_vsplit",
            ["<C-t>"] = "open_tabnew",
            -- Show details (includes hidden file counts in folder)
            ["i"]    = "show_file_details",
          },
        },
      },

      -- Close tree when a file is opened
      event_handlers = {
        {
          event   = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },

      window = {
        position          = "left",
        width             = 35,
        auto_expand_width = false,
      },

      buffers = {
        follow_current_file = { enabled = false },
        show_unloaded       = true,
        window = {
          mappings = { ["bd"] = "buffer_delete" },
        },
      },

      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"]  = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          },
        },
      },
    },
  },

  -- ── Telescope: extend LazyVim's config ───────────────────
  -- Key fix: <leader>ff and <leader>fg always search from the
  -- detected project root (not the current file's directory).
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Override default ff to use project root
      {
        "<leader>ff",
        function()
          local root = LazyVim.root()
          require("telescope.builtin").find_files({ cwd = root })
        end,
        desc = "Find files (project root)",
      },
      {
        "<leader>fg",
        function()
          local root = LazyVim.root()
          require("telescope.builtin").live_grep({ cwd = root })
        end,
        desc = "Live grep (project root)",
      },
      -- Extra picks
      { "<leader>fw", "<cmd>Telescope grep_string<cr>",            desc = "Grep word under cursor" },
      { "<leader>fW", "<cmd>Telescope grep_string word_match=-w<cr>", desc = "Grep WORD (exact)" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>",  desc = "Find buffers" },
      { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in file" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",                desc = "Find keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",               desc = "Find commands" },
      { "<leader>fm", "<cmd>Telescope marks<cr>",                  desc = "Find marks" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>",               desc = "Quickfix list" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>",                    desc = "Find TODOs" },
      -- Git pickers
      { "<leader>gl", "<cmd>Telescope git_commits<cr>",  desc = "Git log" },
      { "<leader>gL", "<cmd>Telescope git_bcommits<cr>", desc = "Git file commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",   desc = "Git status" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>",    desc = "Git stash" },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix    = "  ",
        selection_caret  = " ",
        path_display     = { "truncate" },
        sorting_strategy = "ascending",
        layout_config    = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          width = 0.87, height = 0.80,
        },
   file_ignore_patterns = {
    "node_modules/.*",
    ".git/.*",
    "dist/.*",
    "build/.*",
    "out/.*",
    "target/.*",      -- Rust
    "__pycache__/.*", -- Python
    "%.jpg", "%.png", "%.gif", "%.ico", "%.mp4", "%.mp3", "%.pdf",
  },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
      })
      return opts
    end,
  },

  -- ── which-key: group label overrides ─────────────────────
  -- LazyVim already sets up which-key. We just add group names.
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>f",     group = " Find"           },
        { "<leader>g",     group = " Git"            },
        { "<leader>G",     group = " GitHub"         },
        { "<leader>Gp",    group = "PRs"             },
        { "<leader>Gr",    group = "Reviews"         },
        { "<leader>Gi",    group = "Issues"          },
        { "<leader>t",     group = " Terminal"       },
        { "<leader>x",     group = " Diagnostics"   },
        { "<leader>w",     group = " Window"        },
        { "<leader>b",     group = " Buffer"        },
        { "<leader>h",     group = " Harpoon",       mode = "n" },
        { "<leader>d",     group = " Debug"         },
        { "<leader>r",     group = " Run (C++)"     },
        { "<leader>u",     group = " UI Toggles"   },
        { "<leader>c",     group = " Code"          },
        { "<leader>tl",    group = " TS Helpers"   },
        { "<leader><tab>", group = " Tabs"          },
        { "<leader>gw",    group = " Worktrees"     },
        { "<leader>gh",    group = " Hunks"         },
        { "<leader>gt",    group = " Git Toggles"  },
        { "<leader>m",     group = " Markdown"      },
        { "<leader>R",     group = " REST"          },
      },
    },
  },

  -- ── Trouble: diagnostics panel ────────────────────────────
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols outline" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                     desc = "TODOs" },
      { "]x", function() require("trouble").next({ skip_groups=true, jump=true }) end, desc = "Next trouble item" },
      { "[x", function() require("trouble").prev({ skip_groups=true, jump=true }) end, desc = "Prev trouble item" },
    },
  },

  -- ── Spectre: project-wide search & replace ────────────────
  {
    "nvim-pack/nvim-spectre",
    cmd  = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end,                         desc = "Project search/replace" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word=true }) end, desc = "Search word", mode={"n","v"} },
    },
    opts = { open_cmd = "noswapfile vnew" },
  },
}
