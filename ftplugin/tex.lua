-- Filetype plugin for LaTeX

local lspconfig = require('lspconfig')

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

