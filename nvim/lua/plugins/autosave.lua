return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return ""
        end,
      },
      trigger_events = {
        immediate_save = {
          "BufLeave",
          "FocusLost",
        },
        defer_save = {
          "InsertLeave",
          "TextChanged",
        },
        cancel_deferred_save = {
          "InsertEnter",
        },
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
          return true
        end

        return false
      end,
    },
  },
}
