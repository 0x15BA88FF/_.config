return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    opts = {
        buttons = {
            {
                label = "View Repository",
                url = function(opts)
                    return opts.repo_url
                end
            }
        }
    }
}
