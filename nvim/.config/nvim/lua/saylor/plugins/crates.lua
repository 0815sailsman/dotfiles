return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    completion = {
      crates = { enabled = true },
    },
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
  },
  config = function(_, opts)
    require("crates").setup(opts)
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "Cargo.toml",
      callback = function(ev)
        local crates = require("crates")
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "Crates: " .. desc })
        end
        map("<leader>ct", crates.toggle, "Toggle")
        map("<leader>cr", crates.reload, "Reload")
        map("<leader>cv", crates.show_versions_popup, "Show Versions")
        map("<leader>cf", crates.show_features_popup, "Show Features")
        map("<leader>cu", crates.update_crate, "Update Crate")
        map("<leader>cU", crates.upgrade_crate, "Upgrade Crate")
        map("K", function()
          if crates.popup_available() then
            crates.show_popup()
          else
            vim.lsp.buf.hover()
          end
        end, "Hover / Crate Info")
      end,
    })
  end,
}
