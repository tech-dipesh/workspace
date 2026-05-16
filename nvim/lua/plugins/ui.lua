-- ║  • lualine: VS Code-style, NO clock, valuable info      ║
-- ║  • Visual selection count in statusline                 ║
-- ║  • bufferline: slant + ordinal numbers                  ║
-- ║  • noice: suppress noise                                ║
-- ║  • PDF/image: open with Windows default app             ║
-- ║  • Markdown: disable MD033/MD013/MD026 lint noise       ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- ── tokyonight: VS Code-blue visual selection ─────────────
  {
    "folke/tokyonight.nvim",
    opts = {
      style           = "night",
      transparent     = false,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        functions = {},
        sidebars  = "dark",
        floats    = "dark",
      },
      on_highlights = function(hl, c)
        hl.CurSearch = { bg = c.orange, fg = c.bg, bold = true }
        hl.IncSearch = { bg = c.orange, fg = c.bg, bold = true }
        -- VS Code-style blue visual selection (fixes the faded default)
        hl.Visual    = { bg = "#264F78" }
        hl.VisualNOS = { bg = "#264F78" }
      end,
    },
  },

  -- ── lualine: full VS Code-style rebuild — NO time ─────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)

      -- Visual selection count: shows "3L" or "42C" in visual mode
      local function selection_count()
        local mode = vim.fn.mode()
        if mode ~= "v" and mode ~= "V" and mode ~= "\22" then return "" end
        local ln_start = vim.fn.line("v")
        local ln_end   = vim.fn.line(".")
        local lines    = math.abs(ln_end - ln_start) + 1
        if mode == "V" then
          return lines .. "L selected"
        elseif mode == "\22" then
          local cols = math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1
          return lines .. "L " .. cols .. "C selected"
        else
          if lines == 1 then
            return math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1 .. "C selected"
          end
          return lines .. "L selected"
        end
      end

      -- Macro recording indicator
      local function macro_rec()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and (" REC @" .. reg) or ""
      end

      -- Terminal count
      local function term_count()
        local n = 0
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(w)].buftype == "terminal" then
            n = n + 1
          end
        end
        return n > 0 and (" " .. n .. " term") or ""
      end

      -- Active LSP (short)
      local function lsp_name()
        local cls = vim.lsp.get_active_clients({ bufnr = 0 })
        local ns  = {}
        for _, c in ipairs(cls) do
          if c.name ~= "null-ls" then ns[#ns + 1] = c.name end
        end
        return #ns > 0 and (" " .. table.concat(ns, ",")) or ""
      end

      -- File size
      local function file_size()
        local p = vim.fn.expand("%:p")
        if p == "" then return "" end
        local ok, s = pcall((vim.uv or vim.loop).fs_stat, p)
        if not ok or not s then return "" end
        if s.size < 1024 then return s.size .. "B" end
        if s.size < 1048576 then return ("%.1fKB"):format(s.size / 1024) end
        return ("%.1fMB"):format(s.size / 1048576)
      end

      return {
        options = {
          theme            = "tokyonight",
          globalstatus     = true,
          -- Thin separators like VS Code
          component_separators = { left = "|", right = "|" },
          section_separators   = { left = "",  right = ""  },
          disabled_filetypes   = {
            statusline = { "alpha", "dashboard", "snacks_dashboard" },
          },
        },

        sections = {
          -- A: mode with VS Code naming
          lualine_a = {
            {
              "mode",
              fmt = function(s)
                local map = {
                  NORMAL   = " NORMAL",   INSERT   = " INSERT",
                  VISUAL   = "󰸿 VISUAL",   ["V-LINE"] = "󰸿 V-LINE",
                  ["V-BLOCK"] = "󰸿 V-BLOCK", COMMAND  = " COMMAND",
                  TERMINAL = " TERM",     REPLACE  = " REPLACE",
                  SELECT   = "󰸿 SELECT",
                }
                return map[s] or s
              end,
            },
          },

          -- B: git
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },

          -- C: file + diagnostics + selection + macro
          lualine_c = {
            {
              "filename",
              path    = 1,   -- relative path (like VS Code tabs)
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed  = "[No Name]",
                newfile  = "[New]",
              },
            },
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              colored = true,
            },
            -- Visual selection count (only in visual mode)
            {
              selection_count,
              color = { fg = "#7dcfff", gui = "bold" },
              cond  = function()
                local m = vim.fn.mode()
                return m == "v" or m == "V" or m == "\22"
              end,
            },
            -- Macro recording (only while recording)
            {
              macro_rec,
              color = { fg = "#f7768e", gui = "bold" },
              cond  = function() return vim.fn.reg_recording() ~= "" end,
            },
          },

          -- X: LSP + terminal + file size + filetype
          lualine_x = {
            { lsp_name,   color = { fg = "#9ece6a" } },
            { term_count, color = { fg = "#7dcfff" } },
            { file_size,  color = { fg = "#565f89" } },
            -- Encoding only if non-UTF-8
            {
              "encoding",
              cond = function()
                return (vim.opt.fileencoding:get() or "utf-8") ~= "utf-8"
              end,
            },
            -- File format only if non-unix
            {
              "fileformat",
              icons_enabled = true,
              cond = function() return vim.bo.fileformat ~= "unix" end,
            },
            { "filetype" },
          },

          -- Y: progress percentage
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
          },

          -- Z: line:col (no time)
          lualine_z = {
            { "location", padding = { left = 0, right = 1 } },
          },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },

        extensions = { "neo-tree", "trouble", "lazy", "mason" },
      }
    end,
  },

  -- ── bufferline ────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_extend("force", opts.options or {}, {
        numbers         = "ordinal",
        separator_style = "slant",
        diagnostics     = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local s = ""
          if diag.error   then s = s .. " " .. diag.error   end
          if diag.warning then s = s .. " " .. diag.warning end
          return s
        end,
        show_buffer_close_icons = true,
        show_close_icon         = true,
        hover = { enabled = true, delay = 150, reveal = { "close" } },
      })
      return opts
    end,
  },

  -- ── noice: suppress noisy messages ────────────────────────
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      vim.list_extend(opts.routes, {
        { filter = { event = "msg_show", find = " written"    }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "%d+L, %d+B"  }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "^%d+ lines?" }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "search hit"  }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "Already at"  }, opts = { skip = true } },
        { filter = { event = "msg_show", min_height = 10      }, view = "split" },
      })
      return opts
    end,
  },

  -- ── PDF + Image viewer: Windows default app ───────────────
  -- Opening a .pdf, .png, .jpg etc. in Neovim will instantly
  -- launch Windows' default handler (Edge, Acrobat, Photos…)
  -- and close the empty Neovim buffer.
  -- <leader>mo also works on any file.
  {
    "nvim-lua/plenary.nvim",
    init = function()
      if vim.fn.has("win32") ~= 1 then return end

      local function open_with_windows(path)
        path = path or vim.fn.expand("%:p")
        if path == "" then return end

        -- Use `cmd /c start` — works regardless of which shell Neovim uses
        -- (Git Bash, PowerShell, cmd). The empty "" before the path is
        -- required by `start` when the path contains special chars.
        -- Convert forward slashes to backslashes for Windows
        local winpath = path:gsub("/", "\\")
        vim.fn.system('cmd /c start "" "' .. winpath .. '"')

        vim.notify(
          "Opened: " .. vim.fn.fnamemodify(path, ":t"),
          vim.log.levels.INFO,
          { title = " Windows Viewer", timeout = 1800 }
        )
      end

      -- Keymap: open current file with Windows default app
      vim.keymap.set("n", "<leader>mo", open_with_windows,
        { desc = "Open with Windows app (PDF/image/…)" })

      -- Auto-open when Neovim tries to open a media file as a buffer
      vim.api.nvim_create_autocmd("BufReadPre", {
        group   = vim.api.nvim_create_augroup("win_media_open", { clear = true }),
        pattern = {
          "*.pdf",
          "*.png", "*.jpg", "*.jpeg", "*.gif",
          "*.webp", "*.svg", "*.bmp", "*.ico",
        },
        callback = function(ev)
          open_with_windows(vim.fn.fnamemodify(ev.match, ":p"))
          -- Close the empty buffer Neovim created
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              vim.api.nvim_buf_delete(ev.buf, { force = true })
            end
          end)
        end,
      })
    end,
  },

  -- ── Markdown: suppress noisy lint rules ───────────────────
  -- MD033/MD013/MD026 fire constantly in real README files.
  -- Root fix: stop markdownlint from running entirely in nvim-lint.
  -- marksman LSP still works (completions, links, symbols).
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Remove markdownlint from markdown linters entirely
      if opts.linters_by_ft and opts.linters_by_ft.markdown then
        opts.linters_by_ft.markdown = vim.tbl_filter(function(l)
          return l ~= "markdownlint" and l ~= "markdownlint-cli2"
        end, opts.linters_by_ft.markdown)
      end
      return opts
    end,
  },

  -- Also disable markdownlint if it attaches as an LSP client
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("md_lint_suppress", { clear = true }),
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if c and (c.name == "markdownlint" or c.name == "markdownlint-cli2") then
            -- Stop this client from sending diagnostics to this buffer
            c.handlers["textDocument/publishDiagnostics"] = function() end
            vim.lsp.buf_detach_client(args.buf, args.data.client_id)
          end
        end,
      })
    end,
  },

  -- ── Screenkey ─────────────────────────────────────────────
  {
    "NStefan002/screenkey.nvim",
    lazy = true,
    cmd  = "Screenkey",
    opts = {
      win_opts = {
        row    = vim.o.lines - 6,
        col    = vim.o.columns - 42,
        width  = 40,
        height = 4,
        border = "rounded",
      },
      compress_after = 3,
      clear_after    = 3,
      show_leader    = true,
      group_mappings = true,
    },
  },
}  
