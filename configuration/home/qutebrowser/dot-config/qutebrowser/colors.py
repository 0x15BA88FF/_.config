import json
import os

c = c
config = config


base_dir = os.path.dirname(os.path.abspath(__file__))
palette_path = os.path.join(base_dir, "palettes", "matugen.json")

with open(palette_path, "r") as f:
    palette = json.load(f)

    c.colors.completion.category.bg = palette["primary-container"]
    c.colors.completion.category.border.bottom = palette["surface-variant"]
    c.colors.completion.category.border.top = palette["surface-variant"]
    c.colors.completion.category.fg = palette["on-primary-container"]
    c.colors.completion.even.bg = palette["surface"]
    c.colors.completion.odd.bg = palette["surface"]
    c.colors.completion.fg = palette["on-surface"]
    c.colors.completion.item.selected.bg = palette["secondary-container"]
    c.colors.completion.item.selected.border.top = palette["secondary"]
    c.colors.completion.item.selected.border.bottom = palette["secondary"]
    c.colors.completion.item.selected.fg = palette["on-secondary-container"]
    c.colors.completion.item.selected.match.fg = palette["primary"]
    c.colors.completion.match.fg = palette["primary"]
    c.colors.completion.scrollbar.bg = palette["surface-variant"]
    c.colors.completion.scrollbar.fg = palette["outline"]

    c.colors.downloads.bar.bg = palette["surface"]
    c.colors.downloads.error.bg = palette["error-container"]
    c.colors.downloads.error.fg = palette["on-error-container"]
    c.colors.downloads.start.bg = palette["primary"]
    c.colors.downloads.start.fg = palette["on-primary"]
    c.colors.downloads.stop.bg = palette["secondary"]
    c.colors.downloads.stop.fg = palette["on-secondary"]
    c.colors.downloads.system.bg = "none"
    c.colors.downloads.system.fg = "none"

    c.colors.hints.bg = palette["secondary-container"]
    c.colors.hints.fg = palette["on-secondary-container"]
    c.hints.border = "1px solid " + palette["outline"]
    c.colors.hints.match.fg = palette["primary"]

    c.colors.keyhint.bg = palette["surface"]
    c.colors.keyhint.fg = palette["on-surface"]
    c.colors.keyhint.suffix.fg = palette["primary"]

    c.colors.messages.error.bg = palette["error"]
    c.colors.messages.error.border = palette["on-error"]
    c.colors.messages.error.fg = palette["on-error"]
    c.colors.messages.info.bg = palette["surface"]
    c.colors.messages.info.border = palette["surface-variant"]
    c.colors.messages.info.fg = palette["on-surface"]
    c.colors.messages.warning.bg = palette["error-container"]
    c.colors.messages.warning.border = palette["error"]
    c.colors.messages.warning.fg = palette["on-error-container"]

    c.colors.prompts.bg = palette["surface"]
    c.colors.prompts.border = "1px solid " + palette["outline"]
    c.colors.prompts.fg = palette["on-surface"]
    c.colors.prompts.selected.bg = palette["secondary-container"]
    c.colors.prompts.selected.fg = palette["on-secondary-container"]

    c.colors.statusbar.normal.bg = palette["surface"]
    c.colors.statusbar.normal.fg = palette["on-surface"]
    c.colors.statusbar.insert.bg = palette["primary"]
    c.colors.statusbar.insert.fg = palette["on-primary"]
    c.colors.statusbar.command.bg = palette["surface"]
    c.colors.statusbar.command.fg = palette["on-surface"]
    c.colors.statusbar.passthrough.bg = palette["secondary"]
    c.colors.statusbar.passthrough.fg = palette["on-secondary"]
    c.colors.statusbar.private.bg = palette["inverse-surface"]
    c.colors.statusbar.private.fg = palette["inverse-on-surface"]
    c.colors.statusbar.command.private.bg = palette["inverse-surface"]
    c.colors.statusbar.command.private.fg = palette["inverse-on-surface"]
    c.colors.statusbar.url.fg = palette["on-surface"]
    c.colors.statusbar.url.error.fg = palette["error"]
    c.colors.statusbar.url.success.http.fg = palette["primary"]
    c.colors.statusbar.url.success.https.fg = palette["primary"]
    c.colors.statusbar.url.hover.fg = palette["primary"]
    c.colors.statusbar.url.warn.fg = palette["error"]

    c.colors.tabs.bar.bg = palette["surface-variant"]
    c.colors.tabs.even.bg = palette["surface"]
    c.colors.tabs.odd.bg = palette["surface"]
    c.colors.tabs.even.fg = palette["on-surface"]
    c.colors.tabs.odd.fg = palette["on-surface"]
    c.colors.tabs.selected.even.bg = palette["primary"]
    c.colors.tabs.selected.odd.bg = palette["primary"]
    c.colors.tabs.selected.even.fg = palette["on-primary"]
    c.colors.tabs.selected.odd.fg = palette["on-primary"]
    c.colors.tabs.indicator.error = palette["error"]
    c.colors.tabs.indicator.system = "none"

    c.colors.contextmenu.menu.bg = palette["surface"]
    c.colors.contextmenu.menu.fg = palette["on-surface"]
    c.colors.contextmenu.disabled.bg = palette["surface-variant"]
    c.colors.contextmenu.disabled.fg = palette["outline"]
    c.colors.contextmenu.selected.bg = palette["secondary-container"]
    c.colors.contextmenu.selected.fg = palette["on-secondary-container"]
