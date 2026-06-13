return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    "williamboman/mason.nvim",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue/Start" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    {
      "<leader>db",
      function() require("dap").toggle_breakpoint() end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Conditional Breakpoint",
    },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    {
      "<leader>de",
      function() require("dapui").eval() end,
      mode = { "n", "v" },
      desc = "Debug: Eval",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup({ commented = true })

    -- breakpoint signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "" })

    -- auto open/close the UI
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    ------------------------------------------------------------------
    -- Rust / Tauri backend: codelldb
    -- (rustaceanvim also wires this; defined here so `dap` configs work
    --  even outside a rust buffer, e.g. launching the tauri binary)
    ------------------------------------------------------------------
    local ok, mason_registry = pcall(require, "mason-registry")
    if ok and mason_registry.is_installed("codelldb") then
      local install = mason_registry.get_package("codelldb"):get_install_path()
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = install .. "/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Tauri: debug src-tauri binary",
          type = "codelldb",
          request = "launch",
          program = function()
            -- build first, then point at the produced debug binary
            vim.fn.system("cargo build --manifest-path ./src-tauri/Cargo.toml")
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/src-tauri/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end

    ------------------------------------------------------------------
    -- Angular / TypeScript frontend: js-debug (pwa-chrome)
    -- NOTE: on Linux the Tauri webview is WebKitGTK, which this adapter
    -- cannot attach to. Debug the frontend against `ng serve` in Chrome.
    ------------------------------------------------------------------
    if ok and mason_registry.is_installed("js-debug-adapter") then
      local js_install = mason_registry.get_package("js-debug-adapter"):get_install_path()
      for _, adapter in ipairs({ "pwa-chrome", "pwa-node" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_install .. "/js-debug/src/dapDebugServer.js", "${port}" },
          },
        }
      end

      local frontend = {
        {
          name = "Angular: launch Chrome against ng serve (:4200)",
          type = "pwa-chrome",
          request = "launch",
          url = "http://localhost:4200",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          userDataDir = false,
        },
        {
          name = "Angular: attach to Chrome (port 9222)",
          type = "pwa-chrome",
          request = "attach",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
      for _, ft in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[ft] = frontend
      end
    end
  end,
}
