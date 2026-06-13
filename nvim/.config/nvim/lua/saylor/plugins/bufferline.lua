return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup({
            options = {
                indicator = {
                    icon = "",
                    style = "underline"
                },
                tab_size= 32,
                offsets = {
                {
                    filetype = "neo-tree",
                    text_align = "center",
                    separator = false,
                }
                },
                background= {
                    fg = "white",
                    bg = '#FF006E',
                },
            }
        })
    end
}

