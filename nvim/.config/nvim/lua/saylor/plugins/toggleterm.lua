return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", desc = "Toggle terminal (bottom)" },
      { "<C-t>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup({
        size = 14,
        open_mapping = [[<C-t>]], -- Ctrl-t toggles from any mode (German-keyboard friendly)
        direction = "horizontal", -- dock at the bottom
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
        persist_mode = true,
      })

      -- <leader>tt also toggles the bottom terminal
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal (bottom)" })

      -- terminal-mode conveniences
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          local opts = { buffer = 0 }
          -- escape terminal mode
          vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
          -- hop to other windows without leaving the terminal first
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
          -- toggle off from inside the terminal
          vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>", opts)
        end,
      })
    end,
  },
}
