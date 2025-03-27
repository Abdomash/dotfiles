local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 5, right = 5, top = 5, bottom = 0 }
config.native_macos_fullscreen_mode = true
config.audible_bell = "Disabled"

config.bidi_enabled = true
config.font = wezterm.font_with_fallback({ "Liga SFMono Nerd Font", "Vazir Code Hack" })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.keys = {
  -- Rebind CMD-Left, CMD-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'b', mods = 'ALT', },
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
  },
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'b', mods = 'ALT', },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
  },
}

return config
