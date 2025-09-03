c = c
config = config

config.load_autoconfig()
config.source("colors.py")

c.auto_save.session = True
c.completion.shrink = True
c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem"
]

c.tabs.width = "7%"
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.title.format = " {audio}{current_title}"
c.tabs.padding = {
    "top": 5,
    "bottom": 5,
    "left": 9,
    "right": 9
}
c.tabs.indicator.width = 0
c.tabs.background = True

c.statusbar.show = "never"

c.fonts.default_size = "10pt"
c.fonts.web.size.default = 14
c.fonts.default_family = ["Noto Sans"]
c.fonts.web.family.fixed = "Noto Mono"
c.fonts.web.family.serif = "Noto Serif"
c.fonts.web.family.standard = "Noto Sans"
c.fonts.web.family.sans_serif = "Noto Sans"

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!aw": "https://wiki.archlinux.org/?search={}",
    "!aur": "https://aur.archlinux.org/packages?O=0&K={}",
    "!gh": "https://github.com/search?o=desc&q={}&s=stars",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!wiki": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "!apkg": "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=",

    "!ai": "https://chat.openai.com/chat?q={}",
    "!gai": "https://chat.x.com/?q={}",
    "!cai": "https://claude.ai/chat?q={}",
    "!oai": "https://chat.openai.com/chat?q={}",
    "!pai": "https://www.perplexity.ai/search?q={}",
}

c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
config.set("colors.webpage.darkmode.enabled", False, "file://*")

c.content.proxy = "socks://localhost:9050/"

config.set("content.webgl", False, "*")
config.set("content.geolocation", False)
config.set("content.cookies.store", True)
config.set("content.canvas_reading", False)
config.set("content.cookies.accept", "all")
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")

c.content.blocking.enabled = True
c.content.blocking.adblock.lists = [
    "https://github.com/ewpratten/youtube_ad_blocklist/blob/master/blocklist.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
]

config.bind("cu", "config-source colors.py")
config.bind("cs", "cmd-set-text -s :config-source")
config.bind("tt", "config-cycle tabs.show multiple never")
config.bind("st", "config-cycle statusbar.show always never")
config.bind("pP", "open -- {primary}")
config.bind("pp", "open -- {clipboard}")
config.bind("pt", "open -t -- {clipboard}")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
