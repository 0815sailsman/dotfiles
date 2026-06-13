-- Relative line numbers except for current line
vim.wo.relativenumber = true
vim.wo.number = true
vim.cmd [[
  augroup NumberToggle
    autocmd!
    autocmd CursorMoved,InsertEnter * set number
    autocmd CursorMoved,InsertLeave * set relativenumber
  augroup END
]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- Hilfe-Links mit Enter folgen
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = "help",
  callback = function ()
    vim.keymap.set("n", "<CR>", "<C-]>", {buffer = true})
  end
})


-- Beim Wiederöffnen einer Datei zur letzten Position springen
vim.api.nvim_command([[au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])


-- Einrückung mit 4 Spaces als Standard
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true


-- Aktuelle Einrückung fortführen
vim.o.smartindent = true


-- Undo-Historie abspeichern
vim.opt.undofile = true

-- System-Clipboard verwenden
vim.o.clipboard = 'unnamedplus'

-- IDE-friendly defaults
vim.o.termguicolors = true       -- true color (LSP/treesitter highlights)
vim.o.signcolumn = 'yes'         -- always show sign column (no text shift for diagnostics/git)
vim.o.scrolloff = 8              -- keep context around the cursor
vim.o.splitright = true          -- vertical splits open to the right
vim.o.splitbelow = true          -- horizontal splits open below
vim.o.updatetime = 250           -- faster CursorHold (diagnostics/hover)
vim.o.timeoutlen = 400           -- which-key popup responsiveness
vim.o.cursorline = true          -- highlight current line

vim.filetype.add {
  extension = {
        rasi = 'rasi',
        vert = 'glsl',
        frag = 'glsl'
    },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/kitty/*.conf'] = 'bash',
    ['.*/hypr/.*%.conf'] = 'hyprlang',
  },
}
