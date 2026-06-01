local wezterm = require 'wezterm'
local act = wezterm.action

local shell = os.getenv('SHELL') or '/bin/zsh'
local is_macos = wezterm.target_triple:find('apple%-darwin') ~= nil

local function shell_quote_applescript(value)
  value = tostring(value or '')
  value = value:gsub('\\', '\\\\')
  value = value:gsub('"', '\\"')
  value = value:gsub('[\r\n]+', ' ')
  return '"' .. value .. '"'
end

local function trim(value)
  return tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function is_executable(path)
  return wezterm.run_child_process { '/bin/test', '-x', path }
end

local function current_username()
  local home = os.getenv('HOME') or ''
  return home:match('/([^/]+)$')
end

local function resolve_tmux_command()
  local user = current_username()
  if not user then
    return 'tmux'
  end

  local per_user_tmux = '/etc/profiles/per-user/' .. user .. '/bin/tmux'
  return is_executable(per_user_tmux) and per_user_tmux or 'tmux'
end

local tmux = resolve_tmux_command()

local function notify(title, message)
  if is_macos then
    local script = 'display notification '
      .. shell_quote_applescript(message)
      .. ' with title '
      .. shell_quote_applescript(title)

    wezterm.background_child_process { 'osascript', '-e', script }
  else
    wezterm.background_child_process { 'notify-send', title, message }
  end
end

local function tmux_current_command(pane)
  local tty = pane:get_tty_name()
  if tty == nil or tty == '' then
    return nil
  end

  local success, clients = wezterm.run_child_process {
    tmux,
    'list-clients',
    '-F',
    '#{client_tty}\t#{session_name}:#{window_index}.#{pane_index}',
  }
  if not success then
    return nil
  end

  for line in clients:gmatch('[^\r\n]+') do
    local client_tty, target = line:match('^([^\t]+)\t(.+)$')
    if client_tty == tty then
      local ok, command = wezterm.run_child_process {
        tmux,
        'display-message',
        '-p',
        '-t',
        target,
        '#{pane_current_command}',
      }
      if ok then
        return trim(command)
      end
    end
  end

  return nil
end

local function is_yazi_pane(pane)
  local process_name = pane:get_foreground_process_name() or ''
  if process_name:match('yazi$') then
    return true
  end

  return tmux_current_command(pane) == 'yazi'
end

local function paste_or_yazi_paste(window, pane)
  if is_yazi_pane(pane) then
    window:perform_action(act.SendKey { key = 'p', mods = 'CTRL' }, pane)
    return
  end

  window:perform_action(act.PasteFrom 'Clipboard', pane)
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
  -- keyball
  { key = 'Delete', mods = '', action = act.SendKey { key = 'd', mods = 'CTRL' } },
  { key = 'RightArrow', mods = '', action = act.SendKey { key = 'f', mods = 'CTRL' } },
  { key = 'LeftArrow', mods = '', action = act.SendKey { key = 'b', mods = 'CTRL' } },
  { key = 'UpArrow', mods = '', action = act.SendKey { key = 'p', mods = 'CTRL' } },
  { key = 'DownArrow', mods = '', action = act.SendKey { key = 'n', mods = 'CTRL' } },

  { key = 'q', mods = 'CTRL', action = act.SendString '\x11' },
  { key = '/', mods = 'CTRL', action = act.SendKey { key = '_', mods = 'CTRL' } },

  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = false } },
  { key = 'v', mods = 'CMD', action = wezterm.action_callback(paste_or_yazi_paste) },
  {
    key = 's',
    mods = 'CMD',
    action = act.SpawnCommandInNewTab {
      args = { shell, '-lc', '~/.config/wezterm/ssh.sh' },
    },
  },
}

local font_size = is_macos and 16.0 or 14.0

return {
  font = wezterm.font_with_fallback {
    { family = 'PlemolJP Console NF', assume_emoji_presentation = false },
    { family = 'Symbols Nerd Font Mono', assume_emoji_presentation = false },
    { family = 'Noto Emoji', assume_emoji_presentation = true },
  },
  front_end = 'WebGpu',
  use_ime = true,
  macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL',
  font_size = font_size,
  color_scheme = 'nord',
  allow_square_glyphs_to_overflow_width = 'Always',
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = true,
  window_padding = {
    left = '0.5cell',
    right = '0.5cell',
    top = 0,
    bottom = 0,
  },
  keys = keys,
  enable_wayland = true,
  window_close_confirmation = 'NeverPrompt',
  check_for_updates = false,
}
