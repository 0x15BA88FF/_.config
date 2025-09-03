local g = vim.g
local opt = vim.opt

-- Global variables
g.autoformat = true
g.have_nerd_font = true
g.snacks_animate = false
g.trouble_lualine = true
g.dap_virtual_text = true
g.lazyvim_cmp = "auto"
g.lazyvim_picker = "auto"
g.deprecation_warnings = true

-- Mouse and cursor
opt.mouse = "a"
opt.cursorline = true
opt.cursorlineopt = "both"

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.ruler = true

-- Editing behavior
opt.virtualedit = "block"
opt.showmode = false

-- Search settings
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "nosplit"

-- Command completion
opt.wildmode = "longest:full,full"

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

-- Text wrapping and display
opt.wrap = false
opt.colorcolumn = "80"
opt.linebreak = true
opt.conceallevel = 2

-- Whitespace visualization
opt.list = true
opt.listchars = {
    trail = "·",
    tab = "» ",
    nbsp = "␣",
}

-- Window behavior
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.scrolloff = 10
opt.signcolumn = "yes"
opt.laststatus = 3
opt.winminwidth = 5

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10
opt.pumblend = 10

-- File handling
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Session options
opt.sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
}

-- Messages
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Colors and display
opt.termguicolors = true
opt.isfname:append("@-@")

-- Confirmation and auto-save
opt.confirm = true
opt.autowrite = true

-- Clipboard
opt.clipboard = "unnamedplus"
-- vim.schedule(function()
--      opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
-- end)
