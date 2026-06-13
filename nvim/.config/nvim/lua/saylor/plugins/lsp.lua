return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      ----------------------------------------------------------------------
      -- Diagnostics UI (IntelliJ-style inline errors)
      ----------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      ----------------------------------------------------------------------
      -- Keymaps + inlay hints, applied to every server on attach
      ----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("saylor-lsp-attach", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
          end

          local tb = require("telescope.builtin")
          map("gd", tb.lsp_definitions, "Goto Definition")
          map("gr", tb.lsp_references, "Goto References (Find Usages)")
          map("gi", tb.lsp_implementations, "Goto Implementation")
          map("gy", tb.lsp_type_definitions, "Goto Type Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>D", tb.lsp_document_symbols, "Document Symbols")
          map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
          map("<leader>sh", vim.lsp.buf.signature_help, "Signature Help")
          map("<leader>e", vim.diagnostic.open_float, "Line Diagnostics")

          -- inlay hints (types/param names like IntelliJ), toggle with <leader>th
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })

      ----------------------------------------------------------------------
      -- Mason tool installation
      ----------------------------------------------------------------------
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- formatters
          "stylua",
          "prettierd",
          -- debug adapters
          "codelldb",
          "js-debug-adapter",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "vtsls", -- TypeScript / JavaScript
          "angularls", -- Angular language service
          "eslint", -- linting + fix on save
          "html",
          "cssls",
          "tailwindcss",
          "emmet_language_server",
          "jsonls",
          "taplo", -- TOML (Cargo.toml / tauri.conf)
        },
        -- rust_analyzer is owned by rustaceanvim, never let mason enable it here
        automatic_enable = { exclude = { "rust_analyzer" } },
      })

      ----------------------------------------------------------------------
      -- Per-server config (Neovim 0.11+ vim.lsp.config API)
      ----------------------------------------------------------------------
      -- global defaults (blink completion capabilities for all servers)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            diagnostics = { globals = { "vim" } },
            hint = { enable = true },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = "always" },
            preferences = { importModuleSpecifier = "non-relative" },
          },
        },
      })

      -- eslint: auto-fix on save
      vim.lsp.config("eslint", {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    end,
  },
}
