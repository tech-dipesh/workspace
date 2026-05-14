-- ╔══════════════════════════════════════════════════════════╗
-- ║  Neovim — YouTuber Pro Edition  │  LazyVim Base          ║
-- ║  Windows 11 │ JS/TS │ C++ │ Git/GitHub                  ║
-- ╚══════════════════════════════════════════════════════════╝
-- NOTE: Only lua/ folder is needed. LazyVim handles the rest.

vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- Speed: disable unused built-in providers before anything loads
vim.g.loaded_node_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_perl_provider   = 0
vim.g.loaded_python3_provider = 0

require("config.lazy")
