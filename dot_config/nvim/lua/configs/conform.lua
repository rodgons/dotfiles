local options = {
	lsp_fallback = true,
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "gofumpt", "goimports_reviser", "golines" },
		["*"] = { "codespell" },
		["_"] = { "trim_whitespace" },
	},
}

require("conform").setup(options)
