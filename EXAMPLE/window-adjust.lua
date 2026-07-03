local adjust_keys = {
	{ rhs = "<C-w>h", key = "h", desc = "Go to left window" },
	{ rhs = "<C-w>H", key = "H", desc = "Move window to far left" },
	{ rhs = "<C-w>j", key = "j", desc = "Go to lower window" },
	{ rhs = "<C-w>J", key = "J", desc = "Move window to far bottom" },
	{ rhs = "<C-w>k", key = "k", desc = "Go to upper window" },
	{ rhs = "<C-w>K", key = "K", desc = "Move window to far top" },
	{ rhs = "<C-w>l", key = "l", desc = "Go to right window" },
	{ rhs = "<C-w>L", key = "L", desc = "Move window to far right" },
	{ rhs = "<C-w>o", key = "o", desc = "Close other windows" },
	{ rhs = "<C-w>q", key = "q", desc = "Close current window" },
	{ rhs = "<C-w>s", key = "s", desc = "Split horizontally" },
	{ rhs = "<C-w>T", key = "T", desc = "Break out into new tab" },
	{ rhs = "<C-w>v", key = "v", desc = "Split vertically" },
	{ rhs = "<C-w>w", key = "w", desc = "Switch to next window" },
	{ rhs = "<C-w>x", key = "x", desc = "Swap with next window" },
	{ rhs = "<C-w>+", key = "+", desc = "Increase window height" },
	{ rhs = "<C-w>-", key = "-", desc = "Decrease window height" },
	{ rhs = "<C-w><", key = "<", desc = "Decrease window width" },
	{ rhs = "<C-w>=", key = "=", desc = "Balance windows" },
	{ rhs = "<C-w>>", key = ">", desc = "Increase window width" },
	{ rhs = "<C-w>_", key = "_", desc = "Maximize current window" },
	{ rhs = "<C-w>|", key = "|", desc = "Maximize current window" },
}

return {
	"PoonKinWang/submode.nvim",
	opts = {
		submodes = {
			["window adjust"] = {
				enter_key = "<C-w><C-w>",
				keys = adjust_keys,
			},
		},
	},
}
