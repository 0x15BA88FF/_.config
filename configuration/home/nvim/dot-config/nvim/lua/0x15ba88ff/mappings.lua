local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- better movments
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })

-- better indents
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- switching windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })

-- resize windows
map("n", "<C-S-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-S-J>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-S-K>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-S-L>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffer control
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bufdo bd<cr>", { desc = "Delete All Buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New File Buffer" })

-- tab control
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<S-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>$", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>0", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>D", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- windows
map("n", "<leader>\\", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- lists
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })

-- LSP
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
