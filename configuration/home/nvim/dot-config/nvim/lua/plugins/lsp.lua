return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "saghen/blink.cmp" },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Lua LSP
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            -- Python LSP
            lspconfig.pyright.setup({
                capabilities = capabilities,
                root_dir = util.root_pattern("pyproject.toml", "requirements.txt", ".git"),
                before_init = function(_, config)
                    local venv = os.getenv("VIRTUAL_ENV")
                    if venv then
                        config.settings = config.settings or {}
                        config.settings.python = config.settings.python or {}
                        config.settings.python.pythonPath = venv .. "/bin/python"
                    end
                end,
            })
        end,
    },

    -- Mason LSP Installer
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "lua_ls" },
            })
        end,
    },

    -- Install tools like black, stylua via Mason
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "black",    -- Python formatter
                    "prettier", -- JS/TS formatter
                },
            })
        end,
    },

    -- Conform (code formatter)
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- python = { "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            notify_on_error = true,
        },
    },
}
