vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system {
        "git",
        "clone",
        "--branch=stable",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    }
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:" .. out) end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "0x15ba88ff.plugins" } },
    checker = { enabled = true },
}, require("0x15ba88ff.lazy"))

require("0x15ba88ff.options")

vim.schedule(function()
    require("0x15ba88ff.mappings")
    require("0x15ba88ff.autocmds")
end)
