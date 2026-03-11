vim.o.winborder = "double"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.cursorcolumn = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.ignorecase = true
vim.opt.incsearch = true
vim.o.undofile = true
vim.o.termguicolors = true

local map = vim.keymap.set


map('n', 'k', 'gkzz')
map('n', 'j', 'gjzz')

map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')
map('n', ' ', '<NOP>')


map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')

map({ 'n', 'v', 'x' }, 'y', '"+y')
map({ 'n', 'v', 'x' }, 'p', '"+p')
map({ 'n', 'v', 'x' }, 'd', '"+d')
map({ 'n', 'v', 'x' }, 'c', '"+c')



vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/nvim-mini/mini.extra" },
	{ src = "https://github.com/jiaoshijie/undotree" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/seblyng/roslyn.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("*"),
	},
	{ src = 'https://codeberg.org/ziglang/zig.vim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' }

})
vim.pack.add({
	{
		src = 'https://github.com/JavaHello/spring-boot.nvim',
		version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
	},
	'https://github.com/MunifTanjim/nui.nvim',
	'https://github.com/mfussenegger/nvim-dap',

	'https://github.com/nvim-java/nvim-java',
})

vim.pack.add({
	"https://github.com/rachartier/tiny-code-action.nvim",
})



require("luasnip.loaders.from_vscode").lazy_load()
require "mini.pick".setup()
require "mini.extra".setup()
require "oil".setup()
require "undotree".setup()
require "mini.surround".setup()
require "conform".setup()
require "java".setup()
require "tiny-code-action".setup()
require "roslyn".setup()
require "blink.cmp".setup({
	fuzzy = {
		implementation = "rust",
		prebuilt_binaries = {
			download = true,
		}
	}
})


map('n', '<leader><leader>', ":Pick files<CR>")
map('n', '<leader>/', ":Pick grep_live<CR>")
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>e', ":Oil<CR>")
map({ "n", "x", "v" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command('Undotree', function(opts)
	local args = opts.fargs
	local cmd = args[1]

	local cb = require("undotree")[cmd]

	if cmd == "setup" or cb == nil then
		vim.notify("Invalid subcommand: " .. (cmd or ""), vim.log.levels.ERROR)
	else
		cb()
	end
end, {
	nargs = 1,
	complete = function(arg_lead)
		return vim.tbl_filter(function(cmd)
			return vim.startswith(cmd, arg_lead)
		end, { "toggle", "open", "close" })
	end,
	desc = "Undotree command with subcommands: toggle, open, close",
})
map('n', '<leader>u', ":Undotree toggle<CR>", { silent = true })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			codeLens = { enable = true },
			hint = { enable = true, semicolon = 'Disable' },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = { library = { vim.env.VIMRUNTIME }, },
			checkThirdParty = false,
		},
	},
})


vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- Get the detaching client
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client then
			return
		end
		-- Remove the autocommand to format the buffer on save, if it exists
		if client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
				end

			})
		end
	end,
})

vim.lsp.config('jdtls', {
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-21",
						path = "/opt/jdk-21",
						default = true,
					}
				}
			}
		}
	}
})
vim.lsp.enable({ "lua_ls", "rust_analyzer", "tinymist", "jdtls", "jsonls", "zls", "vtsls", "html", "cssls",
	"cssmodules_ls" })
map('n', '<leader>lf', vim.lsp.buf.format)

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

vim.g.diagnostics_active = true


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
