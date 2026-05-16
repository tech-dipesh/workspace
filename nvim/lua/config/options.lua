-- ╔══════════════════════════════════════════════════════════╗
-- ║  config/options.lua — Editor Settings                   ║
-- ║  Original options preserved + additions                 ║
-- ╚══════════════════════════════════════════════════════════╝

local opt = vim.opt

-- ── From your original options.lua (unchanged) ────────────
vim.opt.guicursor = ""
opt.relativenumber = true
opt.number         = true

-- Tab / Indentation (default; JS/TS overridden to 2 in autocmds)
opt.tabstop     = 2
opt.softtabstop = 2
opt.shiftwidth  = 2
opt.expandtab   = true
opt.smartindent = true

-- Search & UI
opt.wrap         = false
opt.swapfile     = false
opt.backup       = false
opt.undofile     = true
opt.hlsearch     = false
opt.incsearch    = true
opt.termguicolors = true
opt.scrolloff    = 8
opt.signcolumn   = "yes"

-- Listchars — Windows-safe characters only
opt.list      = true
opt.listchars = {
  tab      = "  ",
  trail    = ".",
  nbsp     = "+",
  extends  = ">",
  precedes = "<",
}

-- Clipboard — sync with Windows clipboard (both directions)
-- unnamedplus = every yank/delete/change syncs to Windows clipboard
-- win32yank.exe is bundled with Neovim on Windows automatically
opt.clipboard = "unnamedplus"

-- Default to Downloads on startup if no file opened
if vim.fn.argc() == 0 then
  vim.cmd("cd ~/Downloads")
end

-- ── Additions ─────────────────────────────────────────────
opt.splitbelow    = true
opt.splitright    = true
opt.updatetime    = 150       -- faster hover docs, gitsigns
opt.timeoutlen    = 300       -- faster which-key
opt.pumheight     = 14        -- max items in completion popup
opt.laststatus    = 3         -- single global statusline
opt.cmdheight     = 1
opt.confirm       = true      -- ask before quitting unsaved
opt.inccommand    = "nosplit" -- live preview of :s
opt.ignorecase    = true
opt.smartcase     = true
opt.showmode      = false     -- lualine shows mode
opt.conceallevel  = 2
opt.undolevels    = 10000

-- Folds — treesitter-powered, all open by default
opt.foldmethod   = "expr"
opt.foldexpr     = "nvim_treesitter#foldexpr()"
opt.foldlevel    = 99
opt.foldlevelstart = 99
opt.foldenable   = true

-- Neovim 0.10+ transparent fold line (shows actual code)
if vim.fn.has("nvim-0.10") == 1 then
  opt.foldtext     = ""
  opt.smoothscroll = true
end

-- ── fillchars: ASCII-only — Nerd Font icons are multi-byte
-- and cause "E1511: Wrong number of characters for field foldclose"
-- on Windows terminals that render them as 2-cell wide.
-- Using plain ASCII avoids the crash entirely.
opt.fillchars = {
  foldopen  = "-",   -- open fold indicator
  foldclose = "+",   -- closed fold indicator (was  — multi-byte, crashed)
  fold      = " ",
  foldsep   = " ",
  diff      = "/",
  eob       = " ",   -- hide ~ after last line
}

if vim.fn.executable("rg") == 1 then
  opt.grepprg    = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

vim.g.lazyvim_typescript_no_inlay_hints = true

if vim.fn.has("win32") == 1 then
  opt.shell        = [[C:\Progra~1\Git\bin\bash.exe]]
  opt.shellcmdflag = "-c"
  opt.shellredir   = ">%s 2>&1"
  opt.shellpipe    = "2>&1| tee"
  opt.shellquote   = ""
  opt.shellxquote  = ""
  vim.env.PATH = vim.fn.stdpath("data") .. "\\mason\\bin;" .. vim.env.PATH
end

-- ── Neovide GUI — full polished config ────────────────────
-- Matches your window config: {"window":{"Maximized":{"grid_size":{"width":160,"height":38}}}}
if vim.g.neovide then
  -- Font: JetBrainsMono Nerd Font at size 12 (your original)
  vim.o.guifont = "JetBrainsMono_Nerd_Font:h12"

  -- ── Window: start maximized (matches your JSON config) ──
  -- neovide_fullscreen = false means maximized (not true fullscreen)
  vim.g.neovide_fullscreen = false

  -- Force maximized on startup via WinEnter
  vim.api.nvim_create_autocmd("UIEnter", {
    once     = true,
    callback = function()
      -- neovide_maximize() is the official API for maximized window
      if vim.fn.exists("*neovide_maximize") == 1 then
        vim.fn["neovide_maximize"]()
      end
      -- Fallback: set columns/lines to match 160x38 grid from your JSON
      vim.o.columns = 160
      vim.o.lines   = 38
    end,
  })

  -- ── Appearance ───────────────────────────────────────────
  vim.g.neovide_opacity            = 0.97   -- very slightly transparent
  vim.g.neovide_window_blurred          = true   -- frosted glass blur
  vim.g.neovide_floating_shadow         = true   -- shadow under floating windows
  vim.g.neovide_floating_z_height       = 10
  vim.g.neovide_light_angle_degrees     = 45
  vim.g.neovide_light_radius            = 5

  -- ── Cursor animations (smooth, professional) ─────────────
  vim.g.neovide_cursor_animation_length  = 0.10   -- smooth but responsive
  vim.g.neovide_cursor_trail_size        = 0.6
  vim.g.neovide_cursor_antialiasing      = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_vfx_mode          = "railgun"  -- nice effect without being distracting
  -- Options: "" | "railgun" | "torpedo" | "pixiedust" | "sonicboom" | "ripple" | "wireframe"
  vim.g.neovide_cursor_vfx_opacity       = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_density  = 7.0
  vim.g.neovide_cursor_vfx_particle_speed    = 10.0

  -- ── Scroll ───────────────────────────────────────────────
  vim.g.neovide_scroll_animation_length      = 0.15
  vim.g.neovide_scroll_animation_far_lines   = 1
  vim.g.neovide_unlink_border_highlights     = true

  -- ── Padding (breathing room like VS Code) ────────────────
  vim.g.neovide_padding_top    = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right  = 8
  vim.g.neovide_padding_left   = 8

  -- ── Windows-native clipboard in Neovide ──────────────────
  -- Ctrl+C / Ctrl+V work like a normal Windows app
  vim.keymap.set("n", "<C-s>",     ":w<CR>")
  vim.keymap.set("v", "<C-c>",     '"+y')
  vim.keymap.set({ "n","v" }, "<C-v>", '"+P')
  vim.keymap.set("i",         "<C-v>", "<C-r>+")
  vim.keymap.set("c",         "<C-v>", "<C-r>+")

  -- ── Zoom in/out with Ctrl+= and Ctrl+- ───────────────────
  local function adjust_font(delta)
    local font = vim.o.guifont
    local size = tonumber(font:match(":h(%d+)")) or 12
    local new_size = math.max(8, math.min(32, size + delta))
    vim.o.guifont = font:gsub(":h%d+", ":h" .. new_size)
    vim.notify("Font size: " .. new_size, vim.log.levels.INFO,
      { title = "Neovide", timeout = 800 })
  end
  vim.keymap.set("n", "<C-=>",      function() adjust_font(1)  end, { desc = "Neovide: zoom in"  })
  vim.keymap.set("n", "<C-->",      function() adjust_font(-1) end, { desc = "Neovide: zoom out" })
  vim.keymap.set("n", "<C-0>",      function()
    vim.o.guifont = "JetBrainsMono_Nerd_Font:h12"
    vim.notify("Font size: 12 (reset)", vim.log.levels.INFO, { title = "Neovide", timeout = 800 })
  end, { desc = "Neovide: reset zoom" })
end
