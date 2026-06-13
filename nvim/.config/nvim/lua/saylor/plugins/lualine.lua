return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "neo-tree", "dapui_scopes", "dapui_breakpoints" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        { "filename", path = 1 },
        -- breadcrumbs (current symbol path) from nvim-navic
        {
          function()
            return require("nvim-navic").get_location()
          end,
          cond = function()
            local ok, navic = pcall(require, "nvim-navic")
            return ok and navic.is_available()
          end,
        },
      },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
        },
        {
          -- show active LSP server(s)
          function()
            local names = {}
            for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
              names[#names + 1] = client.name
            end
            return #names > 0 and ("  " .. table.concat(names, ",")) or ""
          end,
        },
        "encoding",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
