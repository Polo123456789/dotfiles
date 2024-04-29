vim.o.ff = "unix"

vim.o.mouse = ""
vim.o.clipboard = "unnamedplus"

vim.o.backup = false
vim.o.fileencoding = "utf8"
vim.o.encoding = "utf-8"
vim.o.number = true
vim.o.relativenumber = true
vim.o.backspace = "indent,eol,start"
vim.o.compatible = false
vim.o.hidden = true

vim.o.wildmenu = true
vim.o.showcmd = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autoindent = true
vim.o.startofline = false
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.confirm = true
vim.o.visualbell = true
vim.o.cmdheight = 2
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200
vim.o.pastetoggle = "<F12>"
vim.o.background = "dark"
vim.o.textwidth = 80
vim.o.lazyredraw = true

vim.o.undofile = true
vim.o.undolevels = 500
vim.o.undoreload = 10000

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.expandtab = false

vim.o.incsearch = true
vim.o.hlsearch = false

if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true
	vim.cmd("colorscheme wombat")
end

vim.o.list = true
