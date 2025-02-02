return {
	'echasnovski/mini.statusline',
	version = false,
	dependencies = {
		{ 'echasnovski/mini.icons', version = false },
		{ 'echasnovski/mini-git', version = false, main = 'mini.git' },
		{ 'echasnovski/mini.diff', version = false },
	},
	init = function()
		require('mini.statusline').setup()
	end,
}
