return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>f", group = "find / file" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "git hunks / help" },
      { "<leader>c", group = "code / crates" },
      { "<leader>r", group = "rename / run (rust)" },
      { "<leader>x", group = "trouble / diagnostics" },
      { "<leader>d", group = "debug" },
      { "<leader>t", group = "terminal / toggle / test" },
      { "<leader>b", group = "buffer" },
      { "<leader>w", group = "workspace" },
      { "<leader>s", group = "search / signature" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
