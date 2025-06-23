return {
	lsp = {
		zls = {
			settings = {
				zls = {
					enable_build_on_save = true,
					semantic_tokens = "partial",
				},
			},
		},
		bashls = {},
	},
	mason = {
		"shellharden",
	},
	treesitter = {
		"zig",
		"bash",
	},
}
