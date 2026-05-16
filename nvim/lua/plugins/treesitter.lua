-- ║  plugins/treesitter.lua — Extends LazyVim treesitter    ║
-- ╚══════════════════════════════════════════════════════════╝
-- LazyVim already ships nvim-treesitter.
-- We extend its opts with more parsers and textobjects.

return {
  -- ── Main treesitter — extend LazyVim's opts ──────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Web stack
        "javascript", "typescript", "tsx", "jsdoc",
        "html", "css", "scss", "json", "jsonc", "graphql",
        -- Backend / infra
        "yaml", "bash", "dockerfile", "sql", "prisma", "toml",
        -- C / C++
        "c", "cpp", "cmake",
        -- Config / Neovim
        "lua", "vim", "vimdoc", "regex",
        -- Docs
        "markdown", "markdown_inline",
        -- Git
        "git_config", "gitcommit", "gitignore", "diff",
      },
      highlight          = { enable = true, additional_vim_regex_highlighting = false },
      indent             = { enable = true },
      incremental_selection = {
        enable  = true,
        keymaps = {
          -- These match your original config
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          scope_incremental = false,
          node_decremental  = "<bs>",
        },
      },
    },
  },

  -- ── Textobjects — use opts= so nvim-treesitter loads first ─
  -- FIXED: require("nvim-treesitter.configs") in config = function()
  -- fails with "module not found" because the plugin may not be
  -- loaded yet at that point. The correct LazyVim pattern is to
  -- extend nvim-treesitter's own opts table — treesitter-textobjects
  -- is a dependency of nvim-treesitter and is configured through it.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer",    desc = "outer function" },
            ["if"] = { query = "@function.inner",    desc = "inner function" },
            ["ac"] = { query = "@class.outer",       desc = "outer class"    },
            ["ic"] = { query = "@class.inner",       desc = "inner class"    },
            ["aa"] = { query = "@parameter.outer",   desc = "outer arg"      },
            ["ia"] = { query = "@parameter.inner",   desc = "inner arg"      },
            ["ab"] = { query = "@block.outer",       desc = "outer block"    },
            ["ib"] = { query = "@block.inner",       desc = "inner block"    },
            ["ai"] = { query = "@conditional.outer", desc = "outer if"       },
            ["al"] = { query = "@loop.outer",        desc = "outer loop"     },
            ["il"] = { query = "@loop.inner",        desc = "inner loop"     },
          },
        },
        move = {
          enable    = true,
          set_jumps = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable        = true,
          swap_next     = { ["<leader>sp"] = "@parameter.inner" },
          swap_previous = { ["<leader>sP"] = "@parameter.inner" },
        },
      },
    },
  },

  -- Keep textobjects as a dependency (no separate config block)
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },

  -- ── Autotag: auto-close/rename HTML/JSX tags ─────────────
  -- Load on InsertEnter is fine — autotag only matters in insert mode
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts  = {},
  },
  -- ── Context commentstring for JSX/TSX comments ────────────
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = { enable_autocmd = false },
  },
}
