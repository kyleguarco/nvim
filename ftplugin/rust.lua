-- Filetype plugin for Rust

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
	settings = {
		['rust-analyzer'] = {}
	}
}

