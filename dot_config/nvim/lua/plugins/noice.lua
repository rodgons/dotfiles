return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	config = function()
		require("noice").setup({
			lsp = {
				signature = { enabled = false },
				hover = { enabled = false },
				message = { enabled = false },
			},
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
