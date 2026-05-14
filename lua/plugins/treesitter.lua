-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/treesitter.lua — Extends LazyVim treesitter    ║
-- ╚══════════════════════════════════════════════════════════╝
-- LazyVim already ships nvim-treesitter.
-- We extend its opts with more parsers and textobjects.

return {
	-- ── Main treesitter — extend LazyVim's opts ──────────────
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- Web stack
				"javascript", "typescript", "tsx", "jsdoc",
				"html", "css", "scss", "json", "jsonc", "graphql",
				-- Backend / infra
				"yaml", "bash", "dockerfile", "sql", "prisma", "toml",
				-- C / C++
				"c", "cpp", "cmake",
				-- Config / Neovim
				"lua", "vim", "vimdoc", "regex",
				-- Docs
				"markdown", "markdown_inline",
				-- Git
				"git_config", "gitcommit", "gitignore", "diff",
			},
			highlight          = { enable = true, additional_vim_regex_highlighting = false },
			indent             = { enable = true },
			incremental_selection = {
				enable  = true,
				keymaps = {
					-- These match your original config
					init_selection    = "<C-space>",
					node_incremental  = "<C-space>",
					scope_incremental = false,
					node_decremental  = "<bs>",
				},
			},
		},
	},

	-- ── Textobjects — extend with your original + more ────────

	-- Textobjects — extend with your original + more
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["ai"] = "@conditional.outer",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
				},
			},
		},
	},
	-- ── Autotag: auto-close/rename HTML/JSX tags ─────────────
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts  = {},
	},

	-- ── Context commentstring for JSX/TSX comments ────────────
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = { enable_autocmd = false },
	},
}
