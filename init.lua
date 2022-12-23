-- INSTALL PACKER IF NOT INSTALLED --

local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
	vim.cmd [[packadd packer.nvim]]
end

-- SETUP PACKER PACKAGES --

require('packer').startup(function(use)
	-- Package manager
	use 'wbthomason/packer.nvim'

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			'j-hui/fidget.nvim',

			-- Additional lua configuration, makes nvim stuff amazing
			'folke/neodev.nvim',
		},
	}

	use { -- Autocompletion
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	}

	use { -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		run = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	}

	use { -- Additional text objects via treesitter
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}

	-- Git related plugins
	use 'tpope/vim-fugitive' -- Create and manage git repos using the :Git editor command
	use 'tpope/vim-rhubarb' -- Allow for mentioning issues and contributers in fugitive commits
	use 'lewis6991/gitsigns.nvim' -- Indicators for when lines are added, deleted or changed

	-- General plugins
	use 'shaunsingh/nord.nvim' -- Nord theme
	use 'nvim-lualine/lualine.nvim' -- Fancier statusline
	use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
	use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
	use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

	-- Plugins for me personally
	use 'Pocco81/auto-save.nvim' -- Autosave
	use 'ixru/nvim-markdown' -- Some basic markdown feautures

	-- Fuzzy Finder (files, lsp, etc)
	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, 'custom.plugins')
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require('packer').sync()
	end
end)

-- RESTART EDITOR WHEN BOOTSTRAPING --

if is_bootstrap then
	-- When we are bootstrapping a configuration, it doesn't
	-- make sense to execute the rest of the init.lua.
	--
	-- You'll need to restart nvim, and then it will work.
	print '=================================='
	print '    Plugins are being installed'
	print '    Wait until Packer completes,'
	print '       then restart nvim'
	print '=================================='
	return
end

-- RECOMPILE PACKER WHEN YOU SAVE THIS CONFIGURATION --

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

-- SETTING BASIC OPTIONS --
-- See `:help vim.o`

vim.cmd("set clipboard+=unnamedplus") -- Use os clipboard
vim.o.hlsearch = false -- Set highlight on search
vim.o.number = true -- Add line numbers
vim.o.relativenumber = true -- Make line numbers relative
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.breakindent = true -- Enable break indent
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.undofile = true -- Save undo history
vim.o.swapfile = false -- Disable swap files

vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true

vim.o.updatetime = 250 -- Decrease update time
vim.wo.signcolumn = 'yes'

vim.o.termguicolors = true -- Set colorscheme
vim.g.nord_borders = true
require('nord').set()

-- SETTING BASIC KEYMAPS --
-- See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move selected up/down with captil K/J in visual mode
vim.keymap.set({ "v", "n" }, "J", ":m'>+1<CR>gv=gv")
vim.keymap.set({ "v", "n" }, "K", ":m'<-2<CR>gv=gv")

-- Move between panes to left/bottom/top/right
vim.keymap.set("n", "<C-h>", "<C-w>h", {})
vim.keymap.set("n", "<C-j>", "<C-w>j", {})
vim.keymap.set("n", "<C-k>", "<C-w>k", {})
vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- Remap up/down for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- For diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- HIGHLIGHT ON YANK --
-- See `:help vim.highlight.on_yank()`

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
	pattern = '*',
})

-- USE LUALINE AS STATUSLINE --
-- See `:help lualine.txt`

require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'auto',
		component_separators = '·',
		section_separators = '',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff' },
		lualine_c = { 'filename' },
		lualine_x = { 'diagnostics', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
}

-- ENABLE AUTOSAVE --
-- See: https://github.com/Pocco81/auto-save.nvim

local autosave = require("auto-save")

autosave.setup({
	enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
	execution_message = {
		message = function() -- message to print on save
			return ("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
		end,
		dim = 0.18, -- dim the color of `message`
		cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
	},
	trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
	-- function that determines whether to save the current buffer or not
	-- (true: save buffer, false: do not save buffer)
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if fn.getbufvar(buf, "&modifiable") == 1 and
		    utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
	write_all_buffers = false, -- write all buffers when the current one meets `condition`
	debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
	callbacks = { -- functions to be executed at different intervals
		enabling = nil, -- ran when enabling auto-save
		disabling = nil, -- ran when disabling auto-save
		before_asserting_save = nil, -- ran before checking `condition`
		before_saving = nil, -- ran before doing the actual save
		after_saving = nil -- ran after doing the actual save
	}
})

-- ENABLE COMMENT.NVIM --

require('Comment').setup()

-- ENABLE `LUKAS-REINEKE/INDENT-BLANKLINE.NVIM` --
-- See `:help indent_blankline.txt`

require('indent_blankline').setup {
	char = '┊',
	show_trailing_blankline_indent = false,
}

-- ENABLE GITSIGNS --
-- See `:help gitsigns.txt`

require('gitsigns').setup {
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '-' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	},
}

-- CONFIGURE TELESCOPE --
-- See `:help telescope` and `:help telescope.setup()`

-- Enable telescope
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Use fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Set telescope keybinds
-- See `:help telescope.builtin`
vim.keymap.set('n', 'ft', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[F]ind [T]ext' })

vim.keymap.set('n', 'ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', 'fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', 'fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', 'fr', require('telescope.builtin').oldfiles, { desc = '[F]ind [R]ecent' })
vim.keymap.set('n', 'fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymaps' })

-- CONFIGURE TREESITTER --
-- See `:help nvim-treesitter`

require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help' },

	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 't', -- Select the variable/brackets/curly braces/square braces/string you are currently inside
			node_incremental = 't', -- Increase your selection by selcting the parent variable/brackets/curly braces...
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']f'] = '@function.outer',
				[']c'] = '@class.outer',
			},
			goto_previous_start = {
				['[f'] = '@function.outer',
				['[c'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_previous = {
				['mu'] = '@parameter.inner',
			},
			swap_next = {
				['md'] = '@parameter.inner',
			},
		},
	},
}

-- LSP SETTINGS --
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- ENABLE LANGUAGE SERVERS --

--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	pyright = {},

	sumneko_lua = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- SETUP NEOVIM LUA CONFIGURATION --
require('neodev').setup()

-- NVIM-CMP SUPPORTS ADDITIONAL COMPLETION CAPABILITIES --
local capabilities = require('cmp_nvim_lsp').default_capabilities(
	vim.lsp.protocol.make_client_capabilities()
)

-- Setup mason --
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}

-- TURN ON LSP STATUS INFORMATION --
require('fidget').setup()

-- NVIM-CMP SETUP --
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}
