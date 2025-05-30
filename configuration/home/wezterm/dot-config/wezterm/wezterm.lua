local wezterm = require "wezterm"

package.path = package.path .. ";" .. wezterm.config_dir .. "/themes/?.lua"

local config = wezterm.config_builder()

config.font_size = 11
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })

config.color_schemes = { ["matugen"] = require("matugen") }
config.color_scheme = "matugen"

config.enable_tab_bar = false
config.front_end = "WebGpu"

return config
