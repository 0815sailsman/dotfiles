return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false, -- rustaceanvim configures itself; it is already lazy on the `rust` filetype
  ft = { "rust" },
  config = function()
    -- Resolve the mason-installed codelldb so we get DAP for free.
    local adapter
    local ok, mason_registry = pcall(require, "mason-registry")
    if ok and mason_registry.is_installed("codelldb") then
      local codelldb = mason_registry.get_package("codelldb")
      local install = codelldb:get_install_path()
      local codelldb_path = install .. "/extension/adapter/codelldb"
      local liblldb_path = install .. "/extension/lldb/lib/liblldb.so"
      adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
    end

    vim.g.rustaceanvim = {
      tools = {
        float_win_config = { border = "rounded" },
      },
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            -- clippy on save (matches IntelliJ inspections)
            checkOnSave = true,
            check = { command = "clippy", extraArgs = { "--no-deps" } },
            procMacro = { enable = true },
            inlayHints = {
              bindingModeHints = { enable = false },
              closingBraceHints = { enable = true },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          },
        },
      },
      dap = adapter and { adapter = adapter } or {},
    }

    -- Rust-specific extras on top of the global LSP keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function(ev)
        local function map(keys, cmd, desc)
          vim.keymap.set("n", keys, cmd, { buffer = ev.buf, desc = "Rust: " .. desc })
        end
        map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code Action")
        map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Runnables")
        map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
        map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand Macro")
        map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover Actions")
      end,
    })
  end,
}
