return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = {
        path = vim.fn.stdpath("config") .. "/snippets",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      require("luasnip.loaders.from_vscode").load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  }
}
