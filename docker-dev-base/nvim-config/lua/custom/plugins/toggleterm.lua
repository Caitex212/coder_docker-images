return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-\\>", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Toggle terminal" },
		},
		opts = {
			direction = "vertical",
			size = 60,
			persist_size = true,
			persist_mode = true,
		},
	},
}
