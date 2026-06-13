return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Outline (Structure)" },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown" },
      layout = { default_direction = "right", min_width = 30 },
      attach_mode = "global",
      filter_kind = false, -- show all symbol kinds
      show_guides = true,
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["l"] = "actions.tree_open",
        ["h"] = "actions.tree_close",
      },
    },
  },
  {
    -- breadcrumbs source consumed by lualine
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if
            client
            and client:supports_method("textDocument/documentSymbol")
            and not require("nvim-navic").is_available(args.buf)
          then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })
    end,
    opts = {
      highlight = true,
      separator = "  ",
      depth_limit = 5,
      lsp = { auto_attach = false },
    },
  },
}
