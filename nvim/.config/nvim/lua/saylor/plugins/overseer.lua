return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerOpen",
    "OverseerRunCmd",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
  },
  keys = {
    { "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    { "<leader>tl", "<cmd>OverseerToggle<cr>", desc = "Task List (toggle)" },
    { "<leader>ta", "<cmd>OverseerQuickAction<cr>", desc = "Task Quick Action" },
    { "<leader>tc", "<cmd>OverseerRunCmd<cr>", desc = "Run Shell Command" },
  },
  opts = {
    strategy = { "toggleterm", direction = "horizontal", open_on_start = true },
    task_list = { direction = "bottom", min_height = 12 },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    -- "Run configurations" for this Tauri v2 + Angular workspace
    local templates = {
      {
        name = "tauri: dev",
        builder = function()
          return { cmd = { "cargo" }, args = { "tauri", "dev" }, name = "tauri dev" }
        end,
        condition = { callback = function() return vim.fn.isdirectory("src-tauri") == 1 end },
      },
      {
        name = "tauri: build",
        builder = function()
          return { cmd = { "cargo" }, args = { "tauri", "build" }, name = "tauri build" }
        end,
        condition = { callback = function() return vim.fn.isdirectory("src-tauri") == 1 end },
      },
      {
        name = "ng: serve",
        builder = function()
          return { cmd = { "npm" }, args = { "start" }, name = "ng serve" }
        end,
        condition = { callback = function() return vim.fn.filereadable("angular.json") == 1 end },
      },
      {
        name = "ng: build",
        builder = function()
          return { cmd = { "npm" }, args = { "run", "build" }, name = "ng build" }
        end,
        condition = { callback = function() return vim.fn.filereadable("angular.json") == 1 end },
      },
      {
        name = "cargo: clippy",
        builder = function()
          return {
            cmd = { "cargo" },
            args = { "clippy", "--all-targets", "--all-features" },
            name = "cargo clippy",
            components = { "default", "on_output_quickfix" },
          }
        end,
        condition = { callback = function() return vim.fn.filereadable("src-tauri/Cargo.toml") == 1 or vim.fn.filereadable("Cargo.toml") == 1 end },
      },
      {
        name = "cargo: test",
        builder = function()
          return { cmd = { "cargo" }, args = { "test" }, name = "cargo test" }
        end,
        condition = { callback = function() return vim.fn.filereadable("src-tauri/Cargo.toml") == 1 or vim.fn.filereadable("Cargo.toml") == 1 end },
      },
    }

    for _, tmpl in ipairs(templates) do
      overseer.register_template({
        name = tmpl.name,
        condition = tmpl.condition,
        builder = tmpl.builder,
      })
    end
  end,
}
