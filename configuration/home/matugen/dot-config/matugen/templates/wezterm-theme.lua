return {
    foreground = "{{colors.on_surface.default.hex}}",
    background = "{{colors.surface.default.hex}}",
    cursor_bg = "{{colors.on_surface.default.hex}}",
    cursor_border = "{{colors.on_surface.default.hex}}",
    cursor_fg = "{{colors.surface.default.hex}}",
    selection_bg = "{{colors.secondary_fixed_dim.default.hex}}",
    selection_fg = "{{colors.on_secondary.default.hex}}",
    ansi = {
        "{{colors.surface.default.hex}}",
        "{{colors.red.default.hex}}",
        "{{colors.green.default.hex}}",
        "{{colors.yellow.default.hex}}",
        "{{colors.blue.default.hex}}",
        "{{colors.magenta.default.hex}}",
        "{{colors.cyan.default.hex}}",
        "{{colors.on_surface.default.hex}}"
    },
    brights = {
        "{{colors.surface_dim.default.hex}}",
        "{{colors.red.default.hex | set_lightness: -10.0}}",
        "{{ colors.green.default.hex | set_lightness: -10.0 }}",
        "{{ colors.yellow.default.hex | set_lightness: -10.0 }}",
        "{{ colors.blue.default.hex | set_lightness: -10.0 }}",
        "{{ colors.magenta.default.hex | set_lightness: -10.0 }}",
        "{{ colors.cyan.default.hex | set_lightness: -10.0 }}",
        "{{colors.on_surface_variant.default.hex}}"
    },
}
