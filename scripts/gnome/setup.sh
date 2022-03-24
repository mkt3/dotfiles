#!/usr/bin/env bash

set -eu

setup_gnome() {
    title "Setting up gnome"

    # set keyrepeat delay
    dconf write /org/gnome/desktop/peripherals/keyboard/delay "uint32 190"
    # set keyrepeat repeat-interval
    dconf write /org/gnome/desktop/peripherals/keyboard/repeat-interval "uint32 28"

    # set close
    dconf write /org/gnome/desktop/wm/keybindings/close "['<Super>q']"
    # set maximize
    dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Primary><Super>period']"

    # set unmaximize
    dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Primary><Super>comma']"

    # set switch-group
    dconf write /org/gnome/desktop/wm/keybindings/switch-group "['<Alt>Tab']"

    # set switch-group-backward
    dconf write /org/gnome/desktop/wm/keybindings/switch-group-backward "['<Shift><Alt>Tab']"

    # set switch-input-source
    dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "@as []"

    # set switch-input-source-backward
    dconf write /org/gnome/desktop/wm/keybindings/switch-input-source-backward "@as []"

    # set panel-main-menu
    dconf write /org/gnome/desktop/wm/keybindings/panel-main-menu "['LaunchB']"

    # set switch-windows
    dconf write /org/gnome/desktop/wm/keybindings/switch-windows "@as []"

    # set switch-windows-backward
    dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "@as []"

    # set toggle-tiled-left
    dconf write /org/gnome/mutter/keybindings/toggle-tiled-left "['<Primary><Super>h']"

    # set toggle-tiled-right
    dconf write /org/gnome/mutter/keybindings/toggle-tiled-right "['<Primary><Super>l']"

    # set toggle-application-view
    dconf write /org/gnome/shell/keybindings/toggle-application-view "@as []"

    # set toggle-message-tray
    dconf write /org/gnome/shell/keybindings/toggle-message-tray "@as []"

    # set toggle-application-view
    dconf write /org/gnome/shell/keybindings/toggle-application-view  "@as []"

    #  set toggle-overview
    dconf write /org/gnome/shell/keybindings/toggle-overview "['<Super>Up']"

    #  set overlay-key
    dconf write /org/gnome/mutter/overlay-key "''"

    # name: caps to ctrl
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"

    # show weekday
    dconf write /org/gnome/desktop/interface/clock-show-weekday true

    # home key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']"

    # eject key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/eject "['Eject']"

    # audio next key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/next "['AudioNext']"

    # audio prev key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/previous "['AudioPrev']"

    # audio play key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/play "['AudioPlay']"

    # volume down key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-down "['AudioLowerVolume']"

    # volume up key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-up "['AudioRaiseVolume']"

    # volume mute key
    dconf write /org/gnome/settings-daemon/plugins/media-keys/volume-mute "['AudioMute']"

    # new terminal mode
    dconf write /org/gnome/terminal/legacy/new-terminal-mode "'tab'"

    # default terminal profile
    dconf write /org/gnome/terminal/legacy/profiles:/:e1c194b2-bbd2-40fc-9914-61d2704fcecf/visible-name "'default'"

    # default terminal profile fonts
    dconf write /org/gnome/terminal/legacy/profiles:/:e1c194b2-bbd2-40fc-9914-61d2704fcecf/font "'Cica 15'"

    # set default terminal profile
    dconf write /org/gnome/terminal/legacy/profiles:/default "'e1c194b2-bbd2-40fc-9914-61d2704fcecf'"

    # terminal profile list
    dconf write /org/gnome/terminal/legacy/profiles:/list "['e1c194b2-bbd2-40fc-9914-61d2704fcecf']"
}
