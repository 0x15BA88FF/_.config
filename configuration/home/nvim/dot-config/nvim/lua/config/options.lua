local g = vim.g
local opt = vim.opt

g.autoformat = true
g.have_nerd_font = true
g.snacks_animate = false
g.trouble_lualine = true
g.dap_virtual_text = true
g.lazyvim_cmp = "auto"
g.lazyvim_picker = "auto"
g.deprecation_warnings = true

opt.mouse = "a"
opt.cursorline = true
opt.cursorlineopt = "both"
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.virtualedit = "block"

opt.showmode = false

opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.wildmode = "longest:full,full"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

opt.wrap = false
opt.colorcolumn = "80"
opt.linebreak = true
opt.conceallevel = 2
opt.list = true
opt.listchars = {
    trail = "·",
    tab = "» ",
    nbsp = "␣"
}
opt.fillchars = {
    foldclose = "",
    foldopen = "",
    foldsep = " ",
    fold = " ",
    diff = "╱",
    eob = " "
}

opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.scrolloff = 10
opt.signcolumn = "yes"
opt.laststatus = 3
opt.winminwidth = 5

opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10
opt.pumblend = 10

opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"

opt.updatetime = 250
opt.timeoutlen = 300

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.foldlevel = 99
opt.termguicolors = true
opt.isfname:append("@-@")

opt.confirm = true
opt.autowrite = true

vim.schedule(function()
    opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)
