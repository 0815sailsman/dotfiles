return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  init = function()
    -- Auto-open the explorer on the left at startup (IDE-style),
    -- but stay out of the way for stdin pipes, diffs, and git commit/rebase buffers.
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("saylor-neotree-autoopen", { clear = true }),
      callback = function()
        if vim.o.diff or vim.fn.argc() == -1 then
          return
        end
        local ft = vim.bo.filetype
        if ft == "gitcommit" or ft == "gitrebase" then
          return
        end
        -- if launched on a directory, neo-tree's own hijack handles it
        local first_arg = vim.fn.argv(0)
        if type(first_arg) == "string" and vim.fn.isdirectory(first_arg) == 1 then
          return
        end
        -- open the tree but keep the cursor in the main editor window
        vim.cmd("Neotree show")
      end,
    })
  end,
  keys = {
    { "<leader>fe", "<cmd>Neotree toggle reveal<cr>", desc = "Explorer (toggle)" },
    { "<leader>fo", "<cmd>Neotree focus<cr>", desc = "Explorer (focus)" },
    { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Git Explorer" },
    { "<leader>be", "<cmd>Neotree buffers<cr>", desc = "Buffer Explorer" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { "node_modules", ".git", "target", "dist" },
        never_show = { ".DS_Store" },
      },
    },
    window = {
      width = 34,
      mappings = {
        ["<space>"] = "none", -- keep leader free
        ["l"] = "open",
        ["h"] = "close_node",
        ["P"] = { "toggle_preview", config = { use_float = true } },
      },
    },
    default_component_configs = {
      indent = { with_expanders = true },
    },
  },
}
