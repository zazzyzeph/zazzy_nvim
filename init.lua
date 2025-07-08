-- Install mini.nvim
-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-- mini.deps - package manager from mini.nvim
require('mini.deps').setup({ path = { package = path_package } })
-- mini.deps function aliases
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- mason.nvim - LSP support
-- Add to current session (install if absent)
add({
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { 'williamboman/mason.nvim' },
})

-- treesitter - lanugage parser / extra features
add({
  source = 'nvim-treesitter/nvim-treesitter',
  -- Use 'master' while monitoring updates in 'main'
  checkout = 'master',
  monitor = 'main',
  -- Perform action after every checkout
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

-- DAP = Debug Anywhere Protocol
add({
  source = 'mfussenegger/nvim-dap'
})

local dap = require 'dap'
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/home/deploy/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003
  }
}

-- Possible to immediately execute code which depends on the added plugin
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'lua',
    'vimdoc',
    'markdown',
    'php',
    'haskell',
    'bash',
    'python',
    'ruby',
    'xml',
    'css',
    'scss',
    'html',
    'javascript'
  },
  highlight = { enable = true },
})

-- color scheme
add({
  source = 'ellisonleao/gruvbox.nvim',
})

-- tidalcycles support
add({
  source = 'tidalcycles/vim-tidal',
})

-- detect / set tabstop & shiftwidth based on the file
add({
  source = 'tpope/vim-sleuth'
})

add({
  source = 'MunifTanjim/prettier.nvim'
})

-- formatter
add({
  source = 'stevearc/conform.nvim',
  depends = {'jose-elias-alvarez/null-ls.nvim'}
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", stop_after_first = true },
    html = { "prettierd", stop_after_first = true },
    css = { "prettierd", stop_after_first = true },
    scss = { "prettierd", stop_after_first = true },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}) 

local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- plugins setup
-- mini.ai - improves (a)rround and (i)nside with macros (q for both quote types, b for any bracket)
require('mini.ai').setup()
-- mini.operators - interpret selection with lua
require('mini.operators').setup()
-- mini.surround - surround operations eg viwsa"
require('mini.surround').setup()
-- mini.bracketed - bunch of shortcuts involving []
require('mini.bracketed').setup()
-- mini.pairs - autopairs brackets / quotes
require('mini.pairs').setup()
-- mini.files - file picker / tool
require('mini.files').setup()
-- mini.pick - fuzzy finder
require('mini.pick').setup()
-- mini.icons - icon library for mini plugins
require('mini.icons').setup()
-- mini.statusline - bottom statusline setup
require('mini.statusline').setup()
-- mini.tabline - list of buffers at top
require('mini.tabline').setup()
-- mini.completion - text completion
require('mini.completion').setup()

local lspconfig = require('lspconfig')

local servers = { 'ts_ls', 'jsonls', 'eslint' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilites = capabilities,
  }
end

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities
}


-- set vim options just before start
now(function()

    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
    vim.keymap.set({"n", "i"}, "<C-S-Bslash>", ":terminal<CR>i")
    vim.keymap.set("t", "<C-S-Bslash>", "<C-Bslash><C-n>")
    vim.keymap.set({"n", "i", "t"}, "<C-p>", ":Pick files<CR>")
    vim.keymap.set("n", "<C-S-f>", ":Pick grep_live<CR>")
    vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<CR>")
    vim.keymap.set("n", "<leader>l", ":bnext<CR>")
    vim.keymap.set("n", "<leader>h", ":bprevious<CR>")

    vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
    vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
    vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
    vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
    vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
    vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end)

    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.laststatus = 2
    vim.o.list = true
    vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
    vim.o.autoindent = true
    vim.o.expandtab = true
    vim.o.shiftwidth = 2
    vim.o.tabstop = 2
    vim.o.scrolloff = 10
    vim.o.clipboard = "unnamedplus"
    vim.o.updatetime = 1000
    vim.o.hlsearch = false
    vim.opt.iskeyword:append("-")
    -- don't save blank buffers to sessions (like neo-tree, trouble etc.)
    vim.opt.sessionoptions:remove('blank')
    vim.opt.ignorecase = true
    vim.opt.smartcase = true

    vim.treesitter.language.register('javascript', 'es6')

    vim.g.tidal_target = "terminal"
    vim.g.tidal_boot = "/home/zazzy/tidal/BootTidal.hs"

    vim.cmd("colorscheme gruvbox")
end)
