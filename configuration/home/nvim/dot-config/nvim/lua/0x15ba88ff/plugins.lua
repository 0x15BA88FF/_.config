return {
    -- Theme
    {
        "RRethy/nvim-base16",
        lazy = false,
        priority = 1000,
        config = function()
            -- Set default theme
            vim.cmd("colorscheme base16-catppuccin-mocha")
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "",
            },
        },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "http",
                },
                sync_install = false,
                auto_install = true,
                ignore_install = {},
                modules = {},
                highlight = {
                    enable = true,
                    disable = function(_, buf)
                        local max_filesize = 100 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
            })
        end,
    },

    -- Completion with blink.cmp
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
        },
        opts_extend = { "sources.default" },
    },

    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
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

    -- Mason
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "pyright", "lua_ls" },
        },
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    json = { "prettier" },
                    css = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
                notify_on_error = true,
            })

            local mason_registry = require("mason-registry")
            local formatters = { "stylua", "black", "prettier" }

            for _, formatter in ipairs(formatters) do
                if not mason_registry.is_installed(formatter) then
                    vim.cmd("MasonInstall " .. formatter)
                end
            end
        end,
    },

    -- File explorer
    {
        "stevearc/oil.nvim",
        dependencies = { "echasnovski/mini.icons" },
        config = function()
            require("oil").setup({
                delete_to_trash = true,
                float = {
                    max_width = 130,
                    max_height = 30,
                },
            })

            vim.keymap.set("n", "<Leader>e", function()
                local dir = require("oil").get_current_dir()
                require("oil").open_float(dir, { preview = {} })
            end, { desc = "Explore current directory" })

            -- Only add tnew keymap if tnew is available
            if pcall(require, "tnew.config") then
                vim.keymap.set("n", "<Leader>et", function()
                    local dir = require("tnew.config").options.dir
                    require("oil").open_float(vim.fn.fnameescape(dir), { preview = {} })
                end, { desc = "Explore tnew directory" })
            end
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup({
                extensions = { fzf = {} },
            })
            require("telescope").load_extension("fzf")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<Leader>fw", builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "LSP references" })
            vim.keymap.set("n", "<Leader>fg", builtin.git_files, { desc = "Git files" })

            if pcall(require, "tnew.config") then
                vim.keymap.set("n", "<leader>ft", function()
                    builtin.live_grep({
                        disable_coordinates = true,
                        prompt_title = "Grep tnew files",
                        search_dirs = { require("tnew.config").options.dir },
                    })
                end, { desc = "Grep tnew files" })
            end
        end,
    },

    -- Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "echasnovski/mini.icons" },
        opts = {},
    },

    -- REST client
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    {
        "vyfor/cord.nvim",
        build = ":Cord update",
        opts = {
            buttons = {
                {
                    label = "View Repository",
                    url = function(opts)
                        return opts.repo_url
                    end,
                },
            },
        },
    },
    {
        "0x15ba88ff/tnew.nvim",
        opts = {},
        cmd = { "Tnew", "TnewClean" },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps",
            },
        },
    },
    { "folke/zen-mode.nvim" },
}
