-- ╔══════════════════════════════════════════════════════════╗
-- ║  config/autocmds.lua                                    ║
-- ║  • Your original autocmds (kept)                        ║
-- ║  • Action toasts (yank/delete/change/macro/visual)      ║
-- ║  • Auto-save on change                                  ║
-- ║  • JS/TS "unterminated string literal" fix              ║
-- ║  • C/C++ false diagnostic suppression                   ║
-- ║  • Inlay hints killed on every LSP attach               ║
-- ╚══════════════════════════════════════════════════════════╝

local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
au("BufReadPost", {
  group = ag("restore_cursor", { clear = true }),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lc   = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lc then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
au("VimResized", {
  group = ag("resize_splits", { clear = true }),
  callback = function() vim.cmd("wincmd =") end,
})

au("BufWritePre", {
  group   = ag("trim_ws", { clear = true }),
  pattern = { "*.ts","*.tsx","*.js","*.jsx","*.json","*.lua",
              "*.cpp","*.h","*.hpp","*.md","*.css","*.scss" },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Indent
au("FileType", {
  group   = ag("js_ts_indent", { clear = true }),
  pattern = { "javascript","javascriptreact","typescript","typescriptreact",
              "json","jsonc","html","css","scss","yaml","markdown" },
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth  = 2
  end,
})

-- C++ Indent
au("FileType", {
  group   = ag("cpp_indent", { clear = true }),
  pattern = { "c","cpp" },
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth  = 4
  end,
})

-- Json
au("FileType", {
  group   = ag("json_conceal", { clear = true }),
  pattern = { "json","jsonc" },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Close with q
au("FileType", {
  group   = ag("close_q", { clear = true }),
  pattern = { "help","lspinfo","man","notify","qf","checkhealth","DressingSelect" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Termainl start with number
au("TermOpen", {
  group = ag("term_settings", { clear = true }),
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.cmd("startinsert")
  end,
})

-- Create parent directory
au("BufWritePre", {
  group = ag("auto_mkdir", { clear = true }),
  callback = function(ev)
    if ev.match:match("^%w%w+://") then return end
    local dir = vim.fn.fnamemodify(ev.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- env fle
au({ "BufRead","BufNewFile" }, {
  group   = ag("dotenv_ft", { clear = true }),
  pattern = ".env*",
  callback = function() vim.opt_local.filetype = "sh" end,
})
au("FileType", {
  group   = ag("disable_legacy_syntax", { clear = true }),
  pattern = { "javascript","javascriptreact","typescript",
              "typescriptreact","c","cpp" },
  callback = function(ev)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then return end
      local ok = pcall(require, "nvim-treesitter")
      if ok then
        vim.api.nvim_buf_call(ev.buf, function()
          if vim.treesitter.highlighter.active[ev.buf] then
            vim.cmd("syntax clear")
          end
        end)
      end
    end, 150)
  end,
})
local function should_autosave()
  if vim.bo.buftype ~= ""           then return false end
  if vim.bo.readonly                then return false end
  if not vim.bo.modified            then return false end
  if vim.fn.expand("%") == ""       then return false end
  if vim.bo.filetype == "gitcommit" then return false end
  if vim.bo.filetype == "gitrebase" then return false end
  return true
end

local function do_autosave()
  if should_autosave() then
    vim.cmd("silent! write")
  end
end

au({ "TextChanged", "InsertLeave", "FocusLost" }, {
  group    = ag("auto_save", { clear = true }),
  callback = do_autosave,
})

au("CursorHold", {
  group    = ag("auto_save_cursorhold", { clear = true }),
  callback = do_autosave,
})

au("TextYankPost", {
  group = ag("action_toast_yank", { clear = true }),
  callback = function()
    -- Flash highlight on yanked region (visual feedback)
    vim.highlight.on_yank({ higroup = "Visual", timeout = 220 })

    local ev    = vim.v.event
    local op    = ev.operator
    local reg   = ev.regname == "" and '"' or ev.regname
    local rtype = ev.regtype
    local lines = ev.regcontents or {}
    local count = #lines

    local function preview()
      if count == 0 or not lines[1] then return "" end
      local raw = lines[1]:gsub("^%s+", "")
      local s   = raw:sub(1, 40)
      return s ~= "" and ('"' .. s .. (raw:len() > 40 and "…" or "") .. '"') or ""
    end

    if op == "y" then
      local kind = rtype == "V"   and (count .. " line" .. (count > 1 and "s" or ""))
                or rtype == "\22" and (count .. "-line block")
                or preview()
      vim.notify("Yanked " .. kind .. "  [" .. reg .. "]",
        vim.log.levels.INFO, { title = " Yank", timeout = 1100 })

    elseif op == "d" then
      local kind = count > 1 and (count .. " lines") or preview()
      vim.notify("Deleted " .. kind,
        vim.log.levels.INFO, { title = " Delete", timeout = 900 })

    elseif op == "c" then
      local kind = count > 1 and (count .. " lines") or preview()
      vim.notify("Changed " .. kind,
        vim.log.levels.INFO, { title = " Change", timeout = 900 })
    end
  end,
})

au("RecordingEnter", {
  group = ag("macro_toast_start", { clear = true }),
  callback = function()
    vim.notify(
      "Recording @" .. vim.fn.reg_recording() .. "  (q to stop)",
      vim.log.levels.WARN,
      { title = " Macro", timeout = 4000 }
    )
  end,
})

au("RecordingLeave", {
  group = ag("macro_toast_stop", { clear = true }),
  callback = function()
    vim.notify(
      "Macro saved  (Q to replay)",
      vim.log.levels.INFO,
      { title = " Macro", timeout = 2000 }
    )
  end,
})

au("LspAttach", {
  group = ag("no_inlay_hints", { clear = true }),
  callback = function(args)
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = args.buf })
    end
  end,
})

au("FileType", {
  group   = ag("gitcommit_settings", { clear = true }),
  pattern = { "gitcommit","gitrebase" },
  callback = function()
    vim.opt_local.spell      = true
    vim.opt_local.textwidth  = 72
    vim.opt_local.colorcolumn = "73"
    vim.opt_local.wrap        = true
    if vim.fn.getline(1) == "" then vim.cmd("startinsert") end
  end,
})

au("BufReadPre", {
  group = ag("large_file", { clear = true }),
  callback = function(ev)
    local ok, stats = pcall((vim.uv or vim.loop).fs_stat, ev.match)
    if ok and stats and stats.size > 500 * 1024 then
      vim.b.large_file = true
      vim.opt_local.foldmethod    = "manual"
      vim.opt_local.spell         = false
      vim.opt_local.undofile      = false
      vim.opt_local.cursorline    = false
      vim.opt_local.relativenumber = false
      vim.notify("Large file: some features disabled", vim.log.levels.WARN,
        { title = "Performance", timeout = 3000 })
    end
  end,
})

-- ══════════════════════════════════════════════════════════
--  PACKAGE.JSON: show npm package versions automatically
-- ══════════════════════════════════════════════════════════
au("BufRead", {
  group   = ag("pkg_json_versions", { clear = true }),
  pattern = "package.json",
  callback = function()
    vim.defer_fn(function()
      local ok, pi = pcall(require, "package-info")
      if ok then pi.show({ force = false }) end
    end, 400)
  end,
})

-- ══════════════════════════════════════════════════════════
--  SILENT PLUGIN UPDATE NOTIFICATION
-- ══════════════════════════════════════════════════════════
au("User", {
  group   = ag("lazy_update_notify", { clear = true }),
  pattern = "LazyCheck",
  callback = function()
    local updates = require("lazy").stats().updates or 0
    if updates > 0 then
      vim.notify(
        ("%d plugin update%s available  (:Lazy update)"):format(
          updates, updates > 1 and "s" or ""),
        vim.log.levels.INFO,
        { title = "lazy.nvim", timeout = 5000 }
      )
    end
  end,
})
