-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/markdown.lua — Markdown preview & rendering    ║
-- ║  Your original markdown-preview.nvim kept +             ║
-- ║  render-markdown for inline rendering                   ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── Your original: markdown-preview.nvim (browser live preview)
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init  = function()
      vim.g.mkdp_filetypes    = { "markdown" }
      vim.g.mkdp_auto_start   = 0
      vim.g.mkdp_auto_close   = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world  = 0
      vim.g.mkdp_open_ip     = ""
      vim.g.mkdp_browser     = ""
      -- Theme matching Neovim colorscheme
      vim.g.mkdp_theme       = "dark"
    end,
    ft   = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>",     desc = "Markdown: Live preview (browser)" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown: Stop preview" },
    },
  },

  -- ── render-markdown.nvim: beautiful inline rendering ─────
  -- LazyVim's markdown extra already includes this.
  -- We just tune the opts here.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled          = true,
      render_modes     = { "n", "c" },   -- render in normal + command mode
      anti_conceal     = { enabled = true },
      heading = {
        enabled    = true,
        sign       = true,
        icons      = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
      },
      code = {
        enabled    = true,
        sign       = false,
        style      = "full",
        border     = "thin",
        above      = " ",
        below      = " ",
        highlight  = "RenderMarkdownCode",
      },
      bullet = {
        enabled = true,
        icons   = { "", "", "●", "○" },
      },
      checkbox = {
        enabled         = true,
        unchecked       = { icon = "  " },
        checked         = { icon = "  " },
        custom = {
          todo    = { raw = "[-]", rendered = "  ", highlight = "RenderMarkdownTodo" },
          blocked = { raw = "[>]", rendered = "  ", highlight = "RenderMarkdownError" },
        },
      },
      pipe_table = {
        enabled   = true,
        preset    = "heavy",   -- heavy borders on tables
        alignment_indicator = "",
        border    = { " ", "═", " ", "║", "╔", "╗", "╚", "╝", "╠", "╣", "╦", "╩", "╬" },
      },
      -- Callouts: > [!NOTE] > [!WARNING] etc.
      callout = {
        note    = { raw = "[!NOTE]",    rendered = "  Note",    highlight = "RenderMarkdownInfo"    },
        tip     = { raw = "[!TIP]",     rendered = "  Tip",     highlight = "RenderMarkdownSuccess" },
        warning = { raw = "[!WARNING]", rendered = "  Warning", highlight = "RenderMarkdownWarn"    },
        caution = { raw = "[!CAUTION]", rendered = "  Caution", highlight = "RenderMarkdownError"   },
        important = { raw = "[!IMPORTANT]", rendered = "  Important", highlight = "RenderMarkdownHint" },
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: Toggle inline render", ft = "markdown" },
    },
  },
}
