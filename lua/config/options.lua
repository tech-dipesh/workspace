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

-- grep with ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg    = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- ── Disable inlay hints globally ──────────────────────────
vim.g.lazyvim_typescript_no_inlay_hints = true

-- ── Shell: Git Bash (your default, as specified) ──────────
-- Uses the exact path you provided.
---- Windows shell configuration (Git Bash)
if vim.fn.has("win32") == 1 then
  -- Use the correct path with proper escaping
  vim.opt.shell = "C:\\\\Progra~1\\\\Git\\\\bin\\\\bash.exe"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellredir = ">%s 2>&1"
  vim.opt.shellpipe = "2>&1| tee"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  
  -- Add mason binaries to PATH
  vim.env.PATH = vim.fn.stdpath("data") .. "\\mason\\bin;" .. vim.env.PATH
end
-- ── Neovide GUI ───────────────────────────────────────────
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono_Nerd_Font:h12"
  vim.g.neovide_opacity            = 0.9
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size       = 0.8
  vim.g.neovide_scroll_animation_length = 0.15
  vim.g.neovide_window_blurred          = true
end
