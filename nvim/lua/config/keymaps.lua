-- ╔══════════════════════════════════════════════════════════╗
-- ║  config/keymaps.lua                                     ║
-- ║  SECTION A — Your original keymaps (UNCHANGED)          ║
-- ║  SECTION B — New additions                              ║
-- ╚══════════════════════════════════════════════════════════╝

local map = vim.keymap.set

local BASH = "C:\\\\Progra~1\\\\Git\\\\bin\\\\bash.exe"
local function get_project_root()
	local markers = { "package.json", ".git", "Makefile", "CMakeLists.txt" }
	local path = vim.fn.expand("%:p:h")
	if path == "" then
		return vim.fn.getcwd()
	end
	for _ = 1, 10 do
		for _, marker in ipairs(markers) do
			if vim.fn.filereadable(path .. "/" .. marker) == 1 or vim.fn.isdirectory(path .. "/" .. marker) == 1 then
				return path
			end
		end
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			break
		end
		path = parent
	end
	return vim.fn.getcwd()
end

local _term_instances = {} -- track all open terminals by ID

local function get_git_info(root)
	-- Branch name
	local branch = vim.fn.system('git -C "' .. root .. '" rev-parse --abbrev-ref HEAD 2>NUL'):gsub("%s+", "")
	if branch == "" or branch:find("fatal") or branch:find("not a git") then
		return nil
	end

	-- Staged + modified counts (fast, single git call)
	local status = vim.fn.system('git -C "' .. root .. '" status --short 2>NUL')
	local staged, modified, untracked = 0, 0, 0
	for line in status:gmatch("[^\n]+") do
		local xy = line:sub(1, 2)
		if xy:sub(1, 1):match("[MADRCU]") then
			staged = staged + 1
		end
		if xy:sub(2, 2):match("[MD]") then
			modified = modified + 1
		end
		if xy == "??" then
			untracked = untracked + 1
		end
	end

	local parts = { " " .. branch }
	if staged > 0 then
		parts[#parts + 1] = "✚" .. staged
	end
	if modified > 0 then
		parts[#parts + 1] = "~" .. modified
	end
	if untracked > 0 then
		parts[#parts + 1] = "?" .. untracked
	end
	return table.concat(parts, " ")
end

local function terminal_title()
	local root = get_project_root()
	local project = vim.fn.fnamemodify(root, ":t")

	-- Terminal instance number
	local id = #_term_instances + 1
	table.insert(_term_instances, id)

	-- Git info
	local git = get_git_info(root) or "  no git"

	-- Diagnostic counts (errors + warnings in current session)
	local diag_err = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
	local diag_warn = #vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
	local diag_str = ""
	if diag_err > 0 then
		diag_str = diag_str .. "  " .. diag_err
	end
	if diag_warn > 0 then
		diag_str = diag_str .. "  " .. diag_warn
	end

	return string.format(" Git Bash  #%d  %s  %s%s", id, project, git, diag_str)
end

local function terminal_footer()
	-- Valuable footer: useful keybinds (no clock)
	return " <Esc><Esc> → normal  │  <C-h/j/k/l> → splits  │  <C-\\> → toggle "
end

-- Track terminal instances — remove on close
vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("term_instance_track", { clear = true }),
	callback = function()
		if #_term_instances > 0 then
			table.remove(_term_instances)
		end
	end,
})

local function open_terminal_n(n)
	-- Open a specific numbered terminal (like VS Code tabs)
	-- Each number = a separate persistent terminal
	Snacks.terminal(BASH, {
		win = {
			position = "bottom",
			height = 0.35,
			title = terminal_title(),
			title_pos = "left",
			footer = terminal_footer(),
			footer_pos = "center",
		},
		cwd = get_project_root(),
		env = { TERM = "xterm-256color" },
		-- Give each terminal a unique ID so Snacks tracks them separately
		id = n and ("term_" .. n) or "term_main",
	})
end

local function open_terminal()
	open_terminal_n(nil)
end

map("n", "<C-\\>", open_terminal, { desc = "Toggle Terminal (Git Bash)" })
map("n", "<leader>t", open_terminal, { desc = "Toggle Terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal mode" })

-- ── Multiple terminals — like VS Code tabs ────────────────
-- Each number opens a separate independent terminal instance.
-- <leader>t1 → terminal 1,  <leader>t2 → terminal 2,  etc.
for i = 1, 5 do
	map("n", "<leader>t" .. i, function()
		open_terminal_n(i)
	end, { desc = "Terminal #" .. i })
end

-- Navigate between split windows from inside terminal
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: go left split" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: go down split" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: go up split" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: go right split" })

-- Window navigation ───────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Go left" })
map("n", "<C-l>", "<C-w>l", { desc = "Go right" })
map("n", "<C-j>", "<C-w>j", { desc = "Go down" })
map("n", "<C-k>", "<C-w>k", { desc = "Go up" })

-- Centered scrolling ──────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Move lines ──────────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Save ────────────────────────────────────────────────────
map({ "n", "i" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clipboard ───────────────────────────────────────────────
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Buffers ─────────────────────────────────────────────────
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

-- Indent in visual — keep selection ───────────────────────
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Reload config ───────────────────────────────────────────
map("n", "<leader>R", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Config" })

-- Screenkey toggle ────────────────────────────────────────
map("n", "<leader>uk", "<cmd>Screenkey toggle<cr>", { desc = "Toggle Screenkey" })

-- Dashboard ───────────────────────────────────────────────
map("n", "<leader>h", function()
	Snacks.dashboard.open()
end, { desc = "Dashboard" })

-- File ops ────────────────────────────────────────────────
map("n", "<leader>n", ":e ", { desc = "Create new file" })
map("n", "<leader>fD", function()
	local file = vim.fn.expand("%:p")
	if file == "" then
		return
	end
	vim.fn.system('del "' .. file .. '"')
	vim.cmd("bdelete!")
	vim.notify("Deleted: " .. file, vim.log.levels.INFO)
end, { desc = "Delete current file" })

-- Select all ──────────────────────────────────────────────
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Macro replay ────────────────────────────────────────────
map("n", "Q", "@q", { desc = "Replay macro @q" })

-- ══════════════════════════════════════════════════════════
--  SECTION B — NEW ADDITIONS
-- ══════════════════════════════════════════════════════════

-- ── Movement ─────────────────────────────────────────────
-- Line extremes (faster than ^ and $)
map({ "n", "x", "o" }, "H", "^", { desc = "Start of line (first non-blank)" })
map({ "n", "x", "o" }, "L", "g_", { desc = "End of line (last non-blank)" })

-- Move lines with Alt+j/k (normal + insert mode)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down (insert)" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up (insert)" })

-- Keep cursor centered on search & jump
map("n", "G", "Gzz", { desc = "Go to end (centered)" })
map("n", "*", "*zzzv", { desc = "Search word fwd (centered)" })
map("n", "#", "#zzzv", { desc = "Search word bwd (centered)" })

-- ── Editing ───────────────────────────────────────────────
-- Join line but keep cursor position
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- Paste in visual without losing register
map("x", "p", [["_dP]], { desc = "Paste (keep register)" })

-- Duplicate line / selection
map("n", "<leader>yl", "<cmd>t.<cr>", { desc = "Duplicate line" })
map("v", "<leader>yl", ":t'><cr>gv", { desc = "Duplicate selection" })

-- Quick blank lines without entering insert
map("n", "<leader>o", "o<esc>", { desc = "Blank line below (stay normal)" })
map("n", "<leader>O", "O<esc>", { desc = "Blank line above (stay normal)" })

-- Quick ; and , at end of line (JS/TS)
map("i", "<A-;>", "<Esc>A;<Esc>", { desc = "Append ; at EOL" })
map("i", "<A-,>", "<Esc>A,<Esc>", { desc = "Append , at EOL" })
map("n", "<A-;>", "A;<Esc>", { desc = "Append ; at EOL" })
map("n", "<A-,>", "A,<Esc>", { desc = "Append , at EOL" })

-- ── Windows / splits ─────────────────────────────────────
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Resize split up" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Resize split down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Resize split left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize split right" })

map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close split" })
map("n", "<leader>wm", function()
	if vim.t._maximized then
		vim.cmd("wincmd =")
		vim.t._maximized = false
	else
		vim.cmd("wincmd |")
		vim.cmd("wincmd _")
		vim.t._maximized = true
	end
	vim.notify(vim.t._maximized and " Maximized" or " Restored", vim.log.levels.INFO, { timeout = 900 })
end, { desc = "Toggle maximize split" })

-- ── Buffer extras ─────────────────────────────────────────
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New empty buffer" })
map("n", "<leader>br", "<cmd>e!<cr>", { desc = "Reload buffer from disk" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin/unpin buffer" })

-- Jump to buffer by number (Alt+1..9)
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer #" .. i })
end

-- ── Tabs ─────────────────────────────────────────────────
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprev<cr>", { desc = "Previous tab" })

-- ── Folds ─────────────────────────────────────────────────
map("n", "zR", "<cmd>set foldlevel=99<cr>", { desc = "Open all folds" })
map("n", "zM", "<cmd>set foldlevel=0<cr>", { desc = "Close all folds" })

-- ── Clipboard ─────────────────────────────────────────────
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Copy file path / name
map("n", "<leader>cp", function()
	local p = vim.fn.expand("%:p")
	vim.fn.setreg("+", p)
	vim.notify("Copied: " .. p, vim.log.levels.INFO, { timeout = 1500 })
end, { desc = "Copy full file path" })

map("n", "<leader>cP", function()
	local p = vim.fn.expand("%:t")
	vim.fn.setreg("+", p)
	vim.notify("Copied: " .. p, vim.log.levels.INFO, { timeout = 1500 })
end, { desc = "Copy file name" })

-- ── Quickfix ──────────────────────────────────────────────
map("n", "[q", function()
	pcall(vim.cmd, "cprev")
	vim.cmd("norm! zz")
end, { desc = "Prev quickfix" })
map("n", "]q", function()
	pcall(vim.cmd, "cnext")
	vim.cmd("norm! zz")
end, { desc = "Next quickfix" })

-- ── Toggle options ────────────────────────────────────────
local function toggle(opt_name, label)
	return function()
		vim.o[opt_name] = not vim.o[opt_name]
		vim.notify(
			(vim.o[opt_name] and "ON" or "OFF") .. ": " .. label,
			vim.log.levels.INFO,
			{ title = "Toggle", timeout = 1000 }
		)
	end
end
map("n", "<leader>us", toggle("spell", "Spell check"), { desc = "Toggle spell" })
map("n", "<leader>uw", toggle("wrap", "Word wrap"), { desc = "Toggle wrap" })
map("n", "<leader>ul", toggle("cursorline", "Cursor line"), { desc = "Toggle cursorline" })
map("n", "<leader>un", toggle("number", "Line numbers"), { desc = "Toggle numbers" })
map("n", "<leader>ur", toggle("relativenumber", "Relative nums"), { desc = "Toggle relativenumber" })

-- Format on save toggle
vim.g.autoformat = true
map("n", "<leader>uf", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.notify(
		(vim.g.autoformat and "ON" or "OFF") .. ": Format on save",
		vim.log.levels.INFO,
		{ title = "Toggle", timeout = 1000 }
	)
end, { desc = "Toggle format on save" })

-- ── Search & replace helpers ─────────────────────────────
-- Replace word under cursor in buffer
map("n", "<leader>rs", ":%s/<C-r><C-w>//gc<Left><Left><Left>", { desc = "Replace word under cursor" })
map("v", "<leader>rs", ":s///gc<Left><Left><Left><Left>", { desc = "Replace in selection" })

-- ── Macro on selection ────────────────────────────────────
map("v", "Q", ":norm @q<cr>", { desc = "Run macro @q on selection" })

-- ── Utilities ─────────────────────────────────────────────
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy (plugin manager)" })
map("n", "<leader>M", "<cmd>Mason<cr>", { desc = "Mason (LSP tools)" })
map("n", "<leader>ui", "<cmd>Inspect<cr>", { desc = "Inspect highlight" })

map("n", "<leader>wc", function()
	local wc = vim.fn.wordcount()
	vim.notify(
		("Words: %d  Chars: %d  Lines: %d"):format(wc.words, wc.chars, vim.fn.line("$")),
		vim.log.levels.INFO,
		{ title = "Count" }
	)
end, { desc = "Word/char/line count" })

-- Open in Windows Explorer
map("n", "<leader>cE", function()
	local dir = vim.fn.expand("%:p:h"):gsub("/", "\\")
	vim.fn.system('explorer "' .. dir .. '"')
end, { desc = "Open folder in Explorer" })

-- Cheatsheet
map("n", "<leader>?", function()
	local cs = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
	if vim.fn.filereadable(cs) == 1 then
		vim.cmd("vsplit " .. cs)
	else
		vim.notify("No cheatsheet found at " .. cs, vim.log.levels.WARN)
	end
end, { desc = "Open cheatsheet" })

-- ── TS/JS: quick console.log ──────────────────────────────
map("n", "<leader>tl", function()
	local word = vim.fn.expand("<cword>")
	local line = vim.api.nvim_get_current_line()
	local indent = line:match("^(%s*)")
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. 'console.log("' .. word .. ':", ' .. word .. ");" })
end, { desc = "TS: Insert console.log" })

map("n", "<leader>tL", function()
	vim.cmd([[%g/console\.log/d]])
	vim.notify("Removed all console.logs", vim.log.levels.INFO)
end, { desc = "TS: Remove all console.logs" })

map("n", "<leader>tT", function()
	vim.cmd("tabnew")
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Open terminal as new tab" })



-- Wrap word/selection with dynamic bracket (fixed)
vim.keymap.set({ "n", "v" }, "<leader>wb", function()
  -- Ask for bracket type
  local bracket = vim.fn.input({
    prompt = "Bracket: [c]urly, [p]aren, [s]quare: ",
    default = "c",
  })
  local left, right
  if bracket == "c" then
    left, right = "{", "}"
  elseif bracket == "p" then
    left, right = "(", ")"
  elseif bracket == "s" then
    left, right = "[", "]"
  else
    vim.notify("Invalid bracket", vim.log.levels.WARN)
    return
  end

  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: wrap the selected text
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    if #lines == 1 then
      -- Single line selection
      local line = lines[1]
      local new_line = line:sub(1, start_col - 1) .. left .. line:sub(start_col, end_col) .. right .. line:sub(end_col + 1)
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, { new_line })
      -- Restore visual selection
      vim.cmd("normal! gv")
    else
      -- Multi-line selection: wrap whole block
      lines[1] = left .. lines[1]
      lines[#lines] = lines[#lines] .. right
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
      -- Restore visual selection
      vim.cmd("normal! gv")
    end
  else
    -- Normal mode: wrap the word under cursor
    local word = vim.fn.expand("<cword>")
    if word == "" then
      vim.notify("No word under cursor", vim.log.levels.WARN)
      return
    end
    local line = vim.api.nvim_get_current_line()
    local cursor_pos = vim.fn.col(".") - 1  -- 0-indexed column
    local word_start, word_end
    -- Find exact word boundaries around cursor
    local left_part = line:sub(1, cursor_pos)
    local right_part = line:sub(cursor_pos + 1)
    word_start = left_part:match(".*[^%w_](%w+)$") or left_part:match("^(%w+)$")
    if word_start then
      word_start = #left_part - #word_start + 1
    else
      -- fallback: use expand("<cword>") positions
      word_start, word_end = line:find("\\<" .. word .. "\\>", cursor_pos + 1)
      if not word_start then
        word_start, word_end = line:find(word, cursor_pos + 1, true)
      end
    end
    if not word_start then
      vim.notify("Could not locate word", vim.log.levels.WARN)
      return
    end
    word_end = word_start + #word - 1
    local new_line = line:sub(1, word_start - 1) .. left .. word .. right .. line:sub(word_end + 1)
    vim.api.nvim_set_current_line(new_line)
    -- Move cursor inside the brackets
    vim.fn.cursor(0, word_start + #left)
  end
end, { desc = "Wrap word/selection with dynamic bracket" })
