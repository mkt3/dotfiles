local wezterm = require 'wezterm';
local shell = os.getenv("SHELL") or "/bin/zsh";

local function applescript_string(value)
  value = tostring(value or '')
  value = value:gsub('\\', '\\\\')
  value = value:gsub('"', '\\"')
  value = value:gsub('[\r\n]+', ' ')
  return '"' .. value .. '"'
end

local function notify(title, message)
  if wezterm.target_triple:find('apple%-darwin') then
    local script = 'display notification ' ..
        applescript_string(message) ..
        ' with title ' ..
        applescript_string(title)
    wezterm.background_child_process { 'osascript', '-e', script }
    return
  end

  wezterm.background_child_process { 'notify-send', title, message }
end

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name ~= 'agent_notify' then
    return
  end

  local title, message = value:match('^([^\n]*)\n?(.*)$')
  if title == nil or title == '' then
    title = 'Codex'
  end
  if message == nil or message == '' then
    message = 'Hook completed'
  end

  notify(title, message)
end)

local keys = {
  {key = "Delete",mods = "",action = wezterm.action.SendKey { key = "d", mods = "CTRL" } }, -- for keyball
  {key = "RightArrow",mods = "",action = wezterm.action.SendKey { key = "f", mods = "CTRL" }}, -- for keyball
  {key = "LeftArrow",mods = "",action = wezterm.action.SendKey { key = "b", mods = "CTRL" }}, -- for keyball
  {key = "UpArrow",mods = "",action = wezterm.action.SendKey { key = "p", mods = "CTRL" }}, -- for keyball
  {key = "DownArrow",mods = "",action = wezterm.action.SendKey { key = "n", mods = "CTRL" }}, -- for keyball
  {key = "q",mods = "CTRL",action = wezterm.action { SendString = "\x11" }},
  {key = "/",mods = "CTRL",action = wezterm.action.SendKey { key = "_", mods = "CTRL" }},
  {key="t",mods="CMD",action=wezterm.action.SpawnTab 'CurrentPaneDomain'},
  {key="w",mods="CMD",action=wezterm.action.CloseCurrentTab{confirm=false}},
  {key="s",mods="CMD",action=wezterm.action.SpawnCommandInNewTab{
    args={shell, "-lc", "~/.config/wezterm/ssh.sh"},
  }},
}

font_size = 14.0
if wezterm.target_triple == 'aarch64-apple-darwin' then
  font_size = 16.0
end


return {
  font = wezterm.font_with_fallback {
    { family = 'PlemolJP Console NF', assume_emoji_presentation = false},
    { family = 'Symbols Nerd Font Mono', assume_emoji_presentation = false},
    { family = 'Noto Emoji', assume_emoji_presentation = true},
  },
  use_ime = true,
  macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL',
  font_size = font_size,
  color_scheme = "nord",
  allow_square_glyphs_to_overflow_width = "Always",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = true,
  window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = 0,
    bottom = 0,
  },
  keys=keys,
  enable_wayland = true,
  window_close_confirmation = 'NeverPrompt',
  check_for_updates = false,
}
