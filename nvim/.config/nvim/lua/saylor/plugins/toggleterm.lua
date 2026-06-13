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
				size = 9,
				open_mapping = [[<C-t>]], -- Ctrl-t toggles from any mode (German-keyboard friendly)
				direction = "horizontal", -- dock at the bottom
				shade_terminals = true,
				start_in_insert = true,
				persist_size = true,
				persist_mode = true,
			})

			-- <leader>tt also toggles the bottom terminal
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal (bottom)" })

			-- switch between / create numbered terminals
			vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<cr>", { desc = "Select terminal" })
			vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Terminal 2" })
			vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Terminal 3" })

			-- bufferline-style winbar listing all open terminals --------------
			vim.api.nvim_set_hl(0, "TermBufActive", { fg = "#ffffff", bg = "#FF006E", bold = true })
			vim.api.nvim_set_hl(0, "TermBufInactive", { fg = "#888888" })

			-- clicking a tab toggles/focuses that terminal
			function _G.toggleterm_switch(id)
				vim.cmd(id .. "ToggleTerm")
			end

			-- builds the winbar string from the current terminal list
			function _G.toggleterm_winbar()
				local ok, term_mod = pcall(require, "toggleterm.terminal")
				if not ok then
					return ""
				end
				local terms = term_mod.get_all()
				table.sort(terms, function(a, b)
					return a.id < b.id
				end)
				local cur = vim.b.toggle_number
				local segs = {}
				for _, t in ipairs(terms) do
					local hl = (t.id == cur) and "%#TermBufActive#" or "%#TermBufInactive#"
					local name = (t.display_name and t.display_name ~= "") and t.display_name or "term"
					-- %<id>@func@ ... %X makes the segment clickable
					segs[#segs + 1] =
						string.format("%%%d@v:lua.toggleterm_switch@%s %d: %s %%X%%*", t.id, hl, t.id, name)
				end
				return table.concat(segs, " ")
			end

			-- terminal-mode conveniences
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "term://*toggleterm#*",
				callback = function()
					local opts = { buffer = 0 }
					-- bufferline-style list of terminals across the top of the window
					vim.wo.winbar = "%{%v:lua.toggleterm_winbar()%}"
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
