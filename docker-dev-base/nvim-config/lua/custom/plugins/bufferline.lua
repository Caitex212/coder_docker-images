return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		opts = {
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
			vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "[B]uffer [D]elete" })
			vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "[B]uffer [P]ick" })
		end,
	},
}
