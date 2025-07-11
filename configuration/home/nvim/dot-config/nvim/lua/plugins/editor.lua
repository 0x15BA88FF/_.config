return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = {
            { "echasnovski/mini.icons", opts = {} }
        },
        config = function()
            require("oil").setup({
                delete_to_trash = true,
                default_file_explorer = false,
                float = {
                    max_width = 80,
                    max_height = 20,
                    preview_split = "right",
                }
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil current directory buffer" })
            vim.keymap.set("n", "<Leader>e", "<CMD>Oil --float<CR>", { desc = "Oil float current directory buffer" })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup { extensions = { fzf = {} } }
            require("telescope").load_extension("fzf")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<Leader>f<CR>", builtin.resume, { desc = "Telescope resume search" })
            vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set("n", "<Leader>fw", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope find buffers" })
            vim.keymap.set("n", "<Leader>fm", builtin.marks, { desc = "Telescope find marks" })

            vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope find help tags" })
            vim.keymap.set("n", "<Leader>fi", builtin.man_pages, { desc = "Telescope find man pages" })

            vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, { desc = "Telescope find LSP references" })

            vim.keymap.set("n", "<Leader>fg", builtin.git_files, { desc = "Telescope find git files" })
            vim.keymap.set("n", "<Leader>fgs", builtin.git_status, { desc = "Telescope find git status" })
            vim.keymap.set("n", "<Leader>fgc", builtin.git_commits, { desc = "Telescope find git commits" })
            vim.keymap.set("n", "<Leader>fgb", builtin.git_branches, { desc = "Telescope find git branches" })

            vim.keymap.set("n", "<leader>fT", function()
                builtin.live_grep({
                    prompt_title = "Grep tnew files",
                    search_dirs = { require("tnew.config").options.dir }
                })
            end, { desc = "Telescope grep tnew files" })
        end,
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            workspaces = {
                { name = "personal", path = "~/vaults/work" }
            }
        }
    }
}
