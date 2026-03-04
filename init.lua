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
local a = 'a'

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

--autocomplete
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect")

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/jiaoshijie/undotree" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
})


require "mini.pick".setup()
require "oil".setup()
require "undotree".setup()
require "mini.surround".setup()
map('n', '<leader><leader>', ":Pick files<CR>")
map('n', '<leader>/', ":Pick grep_live<CR>")
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>e', ":Oil<CR>")

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

vim.lsp.enable({ "lua_ls", "rust_analyzer", "tinymist", })
map('n', '<leader>lf', vim.lsp.buf.format)




vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
