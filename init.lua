require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- Package manager
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
	use { 'hrsh7th/nvim-cmp', requires = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-vsnip',
		'hrsh7th/vim-vsnip'
	}}
	use 'simrat39/rust-tools.nvim'
	use 'nvim-lua/plenary.nvim'
	use { 'sindrets/diffview.nvim', requires = { 'nvim-lua/plenary.nvim' } }
	use 'mfussenegger/nvim-dap'
	use 'nvim-lualine/lualine.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use { "nvim-telescope/telescope-file-browser.nvim", requires = {
		{ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
	}}
	use 'mfussenegger/nvim-jdtls'
end)

do
	-- Like "set" in vimscripts
	local set = vim.opt
	set.laststatus = 2
	
	set.showtabline = 2
	
	-- Tabs over spaces.
	set.tabstop = 4
	set.softtabstop = 1
	set.shiftround = true
	set.shiftwidth = 0
	
	-- View spaces/tabs visually
	set.list = true
	
	-- View line numbers
	set.number = true
	
	-- For VimTeX (https://github.com/lervag/vimtex)
	vim.g.maplocaleader = ","
	
	-- Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap=true, silent=true }
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	
	-- Configure VimTeX
	-- vim.g.vimtex_compiler_method = "latexrun"
	-- vim.g.vimtex_view_method = "zathura"
	-- vim.g.vimtex_view_general_viewer = "evince"
	-- vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
	
	-- Various highlighting changes
	vim.cmd[[
		" Forever make floating dialog backgrounds black. Now I can read my damn text!
		highlight! Pmenu ctermbg=0 ctermfg=13 guibg=NONE
	
		highlight! link CmpItemMenu Comment
		" gray
		highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
		" blue
		highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
		highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
		" light blue
		highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
		highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
		highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
		" pink
		highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
		highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
		" front
		highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
		highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
		highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
	
		" buffer switching
		nnoremap <Leader>b :ls<CR>:b<Space>

		set noexpandtab
	]]
end

local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities(
	vim.lsp.protocol.make_client_capabilities()
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

lspconfig.texlab.setup {
	settings = {
		texlab = {
			auxDirectory = ".",
			bibtexFormatter = "texlab",
			build = {
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
				executable = "latexmk",
				forwardSearchAfter = true,
				onSave = true
			},
			chktex = {
				onEdit = false,
				onOpenAndSave = true
			},
			diagnosticsDelay = 300,
			formatterLineLength = 80,
			latexFormatter = "latexindent",
			latexindent = {
				modifyLineBreaks = false
			}
		}
	}
}

require('rust-tools').setup {}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'dracula',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {}
}

require('nvim-web-devicons').setup {
	-- your personal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	-- override = {
	--	zsh = {
	--		icon = "",
	--		color = "#428850",
	--		cterm_color = "65",
	--		name = "Zsh"
	--	}
	-- },
	-- globally enable default icons (default to false)
	-- will get overriden by `get_icons` option
	default = true
}

local telescope = require('telescope')
local fb = telescope.extensions.file_browser
telescope.setup {
	extensions = {
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
			hidden = true,
			select_buffer = true,
		}
	}
}

telescope.load_extension "file_browser"

vim.api.nvim_set_keymap(
	"n",
	"<space>fb",
	":Telescope file_browser<CR>",
	{ noremap = true }
)

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = ""
}

-- CMP Global setup.
local cmp = require('cmp')
cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			-- Kind icons
			-- This concatonates the icons with the name of the item kind
			vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
			-- Source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[LaTeX]",
			})[entry.source.name]
			return vim_item
		end
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	}),
--	window = {
--		completion = {
--			winhighlight = 'Normal:FloatDocBackground,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
--		},
--		documentation = {
--			winhighlight = 'FloatBorder:NormalFloat'
--		}
--	}
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

require('diffview').setup {}

