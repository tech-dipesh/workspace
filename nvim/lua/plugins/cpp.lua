-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/cpp.lua — C++ tools                            ║
-- ║  clangd_extensions + DAP debugger + gcc quick runner    ║
-- ║  Competitive programming + general projects             ║
-- ╚══════════════════════════════════════════════════════════╝

return {

	-- ── clangd_extensions: enhanced clangd LSP ───────────────
	-- NOTE: clangd itself is installed by Mason in lsp.lua.
	-- This plugin adds extra features on top of the LSP.
	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp" },
		opts = {
			server = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=Google",
				},
				-- Inlay hints: DISABLED as requested
			},
			extensions = {
				inlay_hints = { enabled = false },  -- NO inlay hints
				ast = {
					role_icons = {
						type            = " ",
						declaration     = " ",
						expression      = " ",
						specifier       = " ",
						statement       = " ",
						["template argument"] = " ",
					},
				},
				memory_usage = { border = "rounded" },
				symbol_info  = { border = "rounded" },
			},
		},
		config = function(_, opts)
			local base = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = ok_cmp
			and vim.tbl_deep_extend("force", base, cmp_lsp.default_capabilities())
			or base
			local on_attach = function(client, bufnr)
				-- Disable inlay hints immediately on attach
				if vim.lsp.inlay_hint then
					pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
				end

				local map = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs,
					{ buffer = bufnr, silent = true, desc = desc })
				end

				-- C++ specific shortcuts
				map("<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", "C++: Switch header/source")
				map("<leader>ci", "<cmd>ClangdSymbolInfo<cr>",         "C++: Symbol info")
				map("<leader>cm", "<cmd>ClangdMemoryUsage<cr>",        "C++: Memory usage")

				-- Standard LSP shortcuts
				map("gd",  "<cmd>Telescope lsp_definitions<cr>",       "LSP: Go to definition")
				map("gr",  "<cmd>Telescope lsp_references<cr>",        "LSP: References")
				map("K",   vim.lsp.buf.hover,                          "LSP: Hover docs")
				map("gK",  vim.lsp.buf.signature_help,                 "LSP: Signature help")
				map("<leader>ca", vim.lsp.buf.code_action,             "LSP: Code actions")
				map("<leader>cR", vim.lsp.buf.rename,                  "LSP: Rename")
				map("<leader>cd", vim.diagnostic.open_float,           "LSP: Line diagnostics")
				map("]d", function() vim.diagnostic.goto_next({ float = false }) end, "Next diagnostic")
				map("[d", function() vim.diagnostic.goto_prev({ float = false }) end, "Prev diagnostic")
			end

			opts.server.capabilities = capabilities
			opts.server.on_attach    = on_attach
			require("clangd_extensions").setup(opts)
		end,
	},

	-- ── DAP: Debugger ─────────────────────────────────────────
	{
		"mfussenegger/nvim-dap",
		ft           = { "c", "cpp" },
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = "nvim-neotest/nvim-nio" },
			"theHamsta/nvim-dap-virtual-text",
			"nvim-telescope/telescope-dap.nvim",
		},
		keys = {
			{ "<F5>",        function() require("dap").continue()          end, desc = "DAP: Start/continue",       ft = "cpp" },
			{ "<F9>",        function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
			{ "<F10>",       function() require("dap").step_over()         end, desc = "DAP: Step over" },
			{ "<F11>",       function() require("dap").step_into()         end, desc = "DAP: Step into" },
			{ "<F12>",       function() require("dap").step_out()          end, desc = "DAP: Step out" },
			{ "<leader>du",  function() require("dapui").toggle()          end, desc = "DAP: Toggle UI" },
			{ "<leader>db",  function() require("dap").toggle_breakpoint() end, desc = "DAP: Breakpoint" },
			{ "<leader>dB",  function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end, desc = "DAP: Conditional breakpoint" },
			{ "<leader>dc",  function() require("dap").continue()          end, desc = "DAP: Continue" },
			{ "<leader>di",  function() require("dap").step_into()         end, desc = "DAP: Step into" },
			{ "<leader>do",  function() require("dap").step_over()         end, desc = "DAP: Step over" },
			{ "<leader>dq",  function() require("dap").terminate()         end, desc = "DAP: Terminate" },
			{ "<leader>dr",  function() require("dap").repl.toggle()       end, desc = "DAP: REPL" },
			{ "<leader>dh",  function() require("dap.ui.widgets").hover()  end, desc = "DAP: Hover value", mode={"n","v"} },
		},
		config = function()
			local dap   = require("dap")
			local dapui = require("dapui")

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

			-- Virtual text: show variable values inline while debugging
			require("nvim-dap-virtual-text").setup({
				enabled                     = true,
				highlight_changed_variables = true,
				all_frames                  = false,
			})

			dapui.setup({
				icons = { expanded = "", collapsed = "", current_frame = "" },
				layouts = {
					{ elements = { "scopes","breakpoints","stacks","watches" },
					size = 40, position = "left" },
					{ elements = { "repl","console" },
					size = 10, position = "bottom" },
				},
			})

			-- ── Windows: cppvsdbg adapter ──────────────────────────
			-- Install via Mason: "cpptools"
			if vim.fn.has("win32") == 1 then
				dap.adapters.cppdbg = {
					id      = "cppvsdbg",
					type    = "executable",
					command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7.cmd",
				}
			else
				dap.adapters.cppdbg = {
					id      = "cppdbg",
					type    = "executable",
					command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
				}
			end

			dap.configurations.cpp = {
				{
					name            = "Launch executable",
					type            = "cppdbg",
					request         = "launch",
					program         = function()
						return vim.fn.input("Executable path: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd             = "${workspaceFolder}",
					stopAtEntry     = false,
					externalConsole = false,
					MIMode          = "gdb",
				},
				{
					name    = "Attach to process",
					type    = "cppdbg",
					request = "attach",
					processId = require("dap.utils").pick_process,
					cwd     = "${workspaceFolder}",
				},
			}
			dap.configurations.c = dap.configurations.cpp
		end,
	},

	-- ── C++ Runner (pure Lua, no external plugin) ────────────
	--
	--  ROOT CAUSE OF ld.exe ERROR:
	--  "cannot open output file ... Invalid argument"
	--  = the output exe path contains SPACES (e.g. "Study Material/")
	--  Windows ld.exe cannot handle spaces in the output path
	--  even when quoted inside cmd /C "...".
	--
	--  THE REAL FIX:
	--  Output the exe to the SAME directory as the source file
	--  with the SAME base name: brute.cpp → brute.exe
	--  We convert the directory path to a short 8.3 form using
	--  `cmd /C for %I in ("path") do @echo %~sI` which gives
	--  a space-free path like C:\STUDYM~1\DSA-ST~1\...
	--  Then the linker never sees a space in the output path.
	--
	--  Shortcuts:
	--    <leader>rr  compile + run (same name: brute.cpp → brute.exe)
	--    <leader>ri  compile + run with input.txt stdin (CP)
	--    <leader>rb  compile only (check errors)
	--    <leader>rI  open/create input.txt for test cases
	-- ─────────────────────────────────────────────────────────
	{
		"nvim-lua/plenary.nvim",
		keys = {
			{
				"<leader>rr",
				function()
					vim.cmd("silent! write")

					local src      = vim.fn.expand("%:p")          -- e.g. C:\Study Material\brute.cpp
					local src_dir  = vim.fn.expand("%:p:h")        -- e.g. C:\Study Material
					local basename = vim.fn.expand("%:t:r")        -- e.g. brute  (no extension)
					local ft       = vim.bo.filetype
					local std_flag = ft == "cpp" and "-std=c++17" or "-std=c11"
					local compiler = ft == "cpp" and "g++" or "gcc"

					-- Get the 8.3 short path of the directory (space-free, Windows built-in)
					-- This avoids quoting issues with paths like "Study Material"
					local short_dir_raw = vim.fn.system(
						'cmd /C for %I in ("' .. src_dir .. '") do @echo %~sI'
					)
					local short_dir = short_dir_raw:gsub("[\r\n]", ""):gsub("%s+$", "")

					-- If short path resolution failed, fall back to temp dir
					if short_dir == "" then
						short_dir = os.getenv("TEMP") or "C:\\Temp"
					end

					-- Output exe: same name as source, in short-path directory
					-- brute.cpp → C:\STUDYM~1\brute.exe  (no spaces, no quotes needed)
					local exe_path = short_dir .. "\\" .. basename .. ".exe"

					-- Also get short path of source file for the compiler input
					local short_src_raw = vim.fn.system(
						'cmd /C for %I in ("' .. src .. '") do @echo %~sI'
					)
					local short_src = short_src_raw:gsub("[\r\n]", ""):gsub("%s+$", "")
					if short_src == "" then short_src = src end

					-- Command: compile then run — all paths are space-free 8.3 form
					local cmd = compiler .. " -O2 " .. std_flag
					.. " -o " .. exe_path
					.. " " .. short_src
					.. " && " .. exe_path

					-- Open bottom terminal split
					vim.cmd("botright 15split")
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_win_set_buf(0, buf)

					-- Use Git Bash to run the command
					local bash = [[C:\Progra~1\Git\bin\bash.exe]]
					vim.fn.termopen({ bash, "-c", cmd }, {
						on_exit = function(_, code)
							vim.schedule(function()
								if code == 0 then
									vim.notify(
										"Compiled & ran: " .. basename .. ".exe",
										vim.log.levels.INFO,
										{ title = "C++ Runner", timeout = 2000 }
									)
								else
									vim.notify(
										"Compile/run failed (exit " .. code .. ")",
										vim.log.levels.ERROR,
										{ title = "C++ Runner", timeout = 4000 }
									)
								end
							end)
						end,
					})
					vim.cmd("startinsert")
				end,
				ft   = { "c", "cpp" },
				desc = "C++: Compile & run (brute.cpp → brute.exe)",
			},

			{
				"<leader>ri",
				function()
					-- Competitive programming: compile + run with input.txt piped as stdin
					vim.cmd("silent! write")

					local src      = vim.fn.expand("%:p")
					local src_dir  = vim.fn.expand("%:p:h")
					local basename = vim.fn.expand("%:t:r")
					local ft       = vim.bo.filetype
					local std_flag = ft == "cpp" and "-std=c++17" or "-std=c11"
					local compiler = ft == "cpp" and "g++" or "gcc"

					-- Short paths (space-free)
					local short_dir = vim.fn.system(
						'cmd /C for %I in ("' .. src_dir .. '") do @echo %~sI'
					):gsub("[\r\n%s]+$", "")
					if short_dir == "" then short_dir = os.getenv("TEMP") or "C:\\Temp" end

					local short_src = vim.fn.system(
						'cmd /C for %I in ("' .. src .. '") do @echo %~sI'
					):gsub("[\r\n%s]+$", "")
					if short_src == "" then short_src = src end

					local exe_path   = short_dir .. "\\" .. basename .. ".exe"
					local input_file = src_dir .. "\\input.txt"

					-- Create input.txt if it doesn't exist
					if vim.fn.filereadable(input_file) == 0 then
						vim.fn.writefile(
							{ "-- Add your test input here --" },
							input_file
						)
						vim.notify(
							"Created input.txt in " .. src_dir,
							vim.log.levels.INFO,
							{ title = "C++ Runner" }
						)
					end

					local short_input = vim.fn.system(
						'cmd /C for %I in ("' .. input_file .. '") do @echo %~sI'
					):gsub("[\r\n%s]+$", "")
					if short_input == "" then short_input = input_file end

					local cmd = compiler .. " -O2 " .. std_flag
					.. " -o " .. exe_path
					.. " " .. short_src
					.. " && " .. exe_path .. " < " .. short_input

					vim.cmd("botright 15split")
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_win_set_buf(0, buf)

					local bash = [[C:\Progra~1\Git\bin\bash.exe]]
					vim.fn.termopen({ bash, "-c", cmd }, {})
					vim.cmd("startinsert")
				end,
				ft   = { "c", "cpp" },
				desc = "C++: Compile & run with input.txt (CP)",
			},

			{
				"<leader>rb",
				function()
					-- Compile only — see errors without running
					vim.cmd("silent! write")

					local src      = vim.fn.expand("%:p")
					local src_dir  = vim.fn.expand("%:p:h")
					local basename = vim.fn.expand("%:t:r")
					local ft       = vim.bo.filetype
					local std_flag = ft == "cpp" and "-std=c++17" or "-std=c11"
					local compiler = ft == "cpp" and "g++" or "gcc"

					local short_dir = vim.fn.system(
						'cmd /C for %I in ("' .. src_dir .. '") do @echo %~sI'
					):gsub("[\r\n%s]+$", "")
					if short_dir == "" then short_dir = os.getenv("TEMP") or "C:\\Temp" end

					local short_src = vim.fn.system(
						'cmd /C for %I in ("' .. src .. '") do @echo %~sI'
					):gsub("[\r\n%s]+$", "")
					if short_src == "" then short_src = src end

					local exe_path = short_dir .. "\\" .. basename .. ".exe"
					local cmd = compiler .. " -O2 " .. std_flag
					.. " -o " .. exe_path .. " " .. short_src

					vim.cmd("botright 10split")
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_win_set_buf(0, buf)

					local bash = [[C:\Progra~1\Git\bin\bash.exe]]
					vim.fn.termopen({ bash, "-c", cmd }, {
						on_exit = function(_, code)
							vim.schedule(function()
								if code == 0 then
									vim.notify(
										"No errors — " .. basename .. ".exe ready",
										vim.log.levels.INFO,
										{ title = "C++", timeout = 2000 }
									)
								end
							end)
						end,
					})
					vim.cmd("startinsert")
				end,
				ft   = { "c", "cpp" },
				desc = "C++: Compile only (check errors)",
			},

			{
				"<leader>rI",
				function()
					-- Open/create input.txt for CP test cases
					local src_dir = vim.fn.expand("%:p:h")
					vim.cmd("vsplit " .. src_dir .. "\\input.txt")
				end,
				ft   = { "c", "cpp" },
				desc = "C++: Edit input.txt (CP test cases)",
			},
		},
	},
}
