return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { "echasnovski/mini.icons", opts = {} },
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify"
        }
    }
}
