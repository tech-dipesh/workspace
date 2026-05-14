-- ╔══════════════════════════════════════════════════════════╗
-- ║  config/lazy.lua — LazyVim Bootstrap                    ║
-- ║                                                          ║
-- ║  HOW THIS WORKS:                                         ║
-- ║  • LazyVim/LazyVim  = the base (ships 40+ plugins)      ║
-- ║  • lazyvim.plugins.extras.*  = official add-ons         ║
-- ║  • { import = "plugins" }  = YOUR overrides in lua/plugins/
-- ║                                                          ║
-- ║  lua/plugins/ files NEVER redeclare what LazyVim        ║
-- ║  already provides — they only extend via opts = {}      ║
-- ╚══════════════════════════════════════════════════════════╝

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n\nPress any key to exit…" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- ── 1. LazyVim base ─────────────────────────────────────
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- ── 2. Language extras (LSP + formatter + linter) ────────
    { import = "lazyvim.plugins.extras.lang.typescript"   },
    { import = "lazyvim.plugins.extras.lang.clangd"       },
    { import = "lazyvim.plugins.extras.lang.cmake"        },
    { import = "lazyvim.plugins.extras.lang.json"         },
    { import = "lazyvim.plugins.extras.lang.tailwind"     },
    { import = "lazyvim.plugins.extras.lang.docker"       },
    { import = "lazyvim.plugins.extras.lang.yaml"         },
    { import = "lazyvim.plugins.extras.lang.markdown"     },

    -- ── 3. Formatting / linting extras ───────────────────────
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.linting.eslint"      },

    -- ── 4. Editor extras ─────────────────────────────────────
    { import = "lazyvim.plugins.extras.editor.harpoon2"   },
    { import = "lazyvim.plugins.extras.util.project"      },

    -- ── 5. Coding extras ──────────────────────────────────────
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.yanky"         },

    -- ── 6. UI extras ──────────────────────────────────────────
    { import = "lazyvim.plugins.extras.ui.mini-animate"   },

    -- ── 7. Your plugin overrides (lua/plugins/*.lua) ─────────
    { import = "plugins" },
  },

  -- rocks disabled — not needed and causes Windows issues
  rocks = { enabled = false, hererocks = false },

  defaults  = { lazy = false, version = false },
  install   = { colorscheme = { "tokyonight", "habamax" } },
  checker   = { enabled = true, notify = false },
  change_detection = { notify = false },

  ui = {
    size      = { width = 0.88, height = 0.85 },
    border    = "rounded",
    title     = "  lazy.nvim",
    title_pos = "center",
  },

  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor",
        "zipPlugin", "netrwPlugin",
      },
    },
  },
})
