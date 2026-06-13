return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        file_ignore_patterns = { "node_modules", "%.git/", "target/", "dist/" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "send_to_qflist",
          },
        },
      },
      extensions = {
        fzf = {},
      },
    })
    pcall(telescope.load_extension, "fzf")

    local builtin = require("telescope.builtin")
    -- existing maps (kept)
    vim.keymap.set("n", "<leader>he", builtin.help_tags, { desc = "Help Tags" })
    vim.keymap.set("n", "<leader>fi", builtin.current_buffer_fuzzy_find, { desc = "Find in Buffer" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    -- new IDE-style pickers
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Workspace Diagnostics" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
    vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find Commands" })
    vim.keymap.set("n", "<leader>fs", builtin.resume, { desc = "Resume Last Search" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep Word Under Cursor" })
  end,
}
