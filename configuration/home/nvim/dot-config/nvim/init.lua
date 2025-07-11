vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:" .. out) end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    checker = { enabled = true },
}, require("config.lazy"))


require("config.options")
require("config.autocmds")

vim.schedule(function()
    require("config.mappings")
    require("config.highlights")
end)
