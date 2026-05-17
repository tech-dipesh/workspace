-- ╔══════════════════════════════════════════════════════════╗
-- ║  plugins/lsp.lua — Mason + LSP configuration            ║
-- ║  Based on your original lsp.lua with fixes:             ║
-- ║  • Inlay hints OFF everywhere                           ║
-- ║  • ts_ls no inlay hints                                 ║
-- ║  • clangd handled by cpp.lua (no double-setup)          ║
-- ║  • Windows 11 compatible mason paths                    ║
-- ║  • NO cmp dependency (safe capabilities)                ║
-- ╚══════════════════════════════════════════════════════════╝

return {

  -- Mason: auto-install LSP servers + tools
  {
    "mason-org/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "eslint-lsp",
        "yaml-language-server",
        "dockerfile-language-server",
        "bash-language-server",
        "clangd",
        -- Formatters
        "prettierd",
        "stylua",
        "clang-format",
        -- Linters
        "eslint_d",
      },
      ui = {
        border = "rounded",
        icons  = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- mason-lspconfig: bridge mason -> lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", "jsonls", "html", "cssls",
        "tailwindcss", "eslint", "yamlls",
        "dockerls", "bashls",
      },
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig: configure each server
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("neodev").setup({})

      -- Safe capabilities (NO cmp dependency)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      }

      -- Diagnostics UI
      vim.diagnostic.config({
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        virtual_text = {
          spacing = 4,
          source  = "if_many",
          prefix  = "●",
        },
        float = {
          border  = "rounded",
          source  = true,
          max_width = 80,
        },
      })

      -- on_attach: keymaps when LSP connects to a buffer
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs,
            { buffer = bufnr, silent = true, desc = desc })
        end

        -- Go-to
        map("n", "gd",  "<cmd>Telescope lsp_definitions<cr>",      "LSP: Go to definition")
        map("n", "gD",  vim.lsp.buf.declaration,                   "LSP: Go to declaration")
        map("n", "gr",  "<cmd>Telescope lsp_references<cr>",       "LSP: References")
        map("n", "gI",  "<cmd>Telescope lsp_implementations<cr>",  "LSP: Implementations")
        map("n", "gy",  "<cmd>Telescope lsp_type_definitions<cr>", "LSP: Type definition")
        -- Hover / signature
        map("n", "K",   vim.lsp.buf.hover,            "LSP: Hover docs")
        map("n", "gK",  vim.lsp.buf.signature_help,   "LSP: Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "LSP: Signature help (insert)")
        -- Actions
        map({ "n","v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code actions")
        map("n",         "<leader>cR", vim.lsp.buf.rename,      "LSP: Rename symbol")
        map("n",         "<leader>cf", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, "LSP: Format")
        -- Diagnostics
        map("n", "<leader>cd", vim.diagnostic.open_float, "LSP: Line diagnostics")
        map("n", "]d", function() vim.diagnostic.goto_next({ float = false }) end, "LSP: Next diagnostic")
        map("n", "[d", function() vim.diagnostic.goto_prev({ float = false }) end, "LSP: Prev diagnostic")
        map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = false }) end, "LSP: Next error")
        map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = false }) end, "LSP: Prev error")
        -- Symbols
        map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>",          "LSP: Document symbols")
        map("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "LSP: Workspace symbols")
      end

      local lsp = require("lspconfig")

      -- Lua
      lsp.lua_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          Lua = {
            workspace   = { checkThirdParty = false },
            completion  = { callSnippet = "Replace" },
            hint        = { enable = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- JSON (with SchemaStore schemas)
      lsp.jsonls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          json = {
            schemas  = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- HTML / CSS / Tailwind
      lsp.html.setup({       capabilities = capabilities, on_attach = on_attach })
      lsp.cssls.setup({      capabilities = capabilities, on_attach = on_attach })
      lsp.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })

      -- ESLint (auto-fix on save)
      lsp.eslint.setup({
        capabilities = capabilities,
        on_attach    = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer  = bufnr,
            command = "EslintFixAll",
          })
        end,
        settings = { workingDirectory = { mode = "auto" } },
      })

      -- YAML / Docker / Bash
      lsp.yamlls.setup({    capabilities = capabilities, on_attach = on_attach })
      lsp.dockerls.setup({  capabilities = capabilities, on_attach = on_attach })
      lsp.bashls.setup({    capabilities = capabilities, on_attach = on_attach })

      -- TypeScript / JavaScript (ts_ls)
      lsp.ts_ls.setup({
        capabilities = capabilities,
        on_attach    = on_attach,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints                         = "none",
              includeInlayParameterNameHintsWhenArgumentMatchesName  = false,
              includeInlayFunctionParameterTypeHints                 = false,
              includeInlayVariableTypeHints                          = false,
              includeInlayPropertyDeclarationTypeHints               = false,
              includeInlayFunctionLikeReturnTypeHints                = false,
              includeInlayEnumMemberValueHints                       = false,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints                         = "none",
              includeInlayParameterNameHintsWhenArgumentMatchesName  = false,
              includeInlayFunctionParameterTypeHints                 = false,
              includeInlayVariableTypeHints                          = false,
              includeInlayPropertyDeclarationTypeHints               = false,
              includeInlayFunctionLikeReturnTypeHints                = false,
              includeInlayEnumMemberValueHints                       = false,
            },
          },
        },
      })

      -- NOTE: clangd is configured in plugins/cpp.lua via clangd_extensions.
      -- Do NOT set up clangd here to avoid conflicts.
    end,
  },

  -- Fidget: LSP loading progress spinner
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        display = {
          render_limit = 4,
          done_ttl     = 1.5,
          done_icon    = "✓",
        },
      },
      notification = {
        window = { winblend = 5, border = "rounded" },
      },
    },
  },

  -- neodev: Neovim Lua API completions
  { "folke/neodev.nvim",     lazy = true },
  { "b0o/SchemaStore.nvim",  lazy = true },
}
