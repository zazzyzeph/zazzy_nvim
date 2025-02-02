vim.g.mapleader = ' '
require('zazzy.remaps')

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- wrapping
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.linebreak = true

-- clipboard = system clipboard
vim.opt.clipboard = "unnamedplus"

-- indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- scroll behavior
vim.opt.scrolloff = 5

-- dont highlight searches
vim.opt.hlsearch = false

-- splits
vim.opt.splitright = true
