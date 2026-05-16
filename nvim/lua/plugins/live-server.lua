-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/live-server.lua — Your original, unchanged     ║
-- ╚══════════════════════════════════════════════════════════╝

return {
  "selimacerbas/live-server.nvim",
  dependencies = { "folke/which-key.nvim", "nvim-telescope/telescope.nvim" },
  opts = {
    default_port  = 8000,
    open_on_start = true,
    live_reload   = {
      enabled      = true,
      inject_script = true,
      debounce     = 120,
      css_inject   = true,
    },
    auto_start = {
      filetypes = { "html" },
      port      = 8000,
    },
  },
  keys = {
    { "<F5>", "<cmd>LiveServerStart<cr>", desc = "Live Server: Start" },
    { "<F6>", "<cmd>LiveServerStop<cr>",  desc = "Live Server: Stop" },
    { "<F7>", "<cmd>LiveServerOpen<cr>",  desc = "Live Server: Open in browser" },
  },
}
