# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# define timeout for multipurpose_modmap
define_timeout(1)

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
})

# [Conditional modmap] Change modifier keys in certain applications
define_conditional_modmap(re.compile(r'Emacs'), {
    Key.CAPSLOCK: Key.LEFT_CTRL,
    Key.RIGHT_CTRL: Key.ESC,
#    Key.LEFT_ALT: Key.LEFT_META,
    Key.LEFT_META: Key.LEFT_ALT,
})

# [Multipurpose modmap] Give a key two meanings. A normal key when pressed and
# released, and a modifier key when held down with another key. See Xcape,
# Carabiner and caps2esc for ideas and concept.
define_multipurpose_modmap(
    # Enter is enter when pressed and released. Control when held down.
    {Key.ENTER: [Key.ENTER, Key.RIGHT_CTRL]}

    # Capslock is escape when pressed and released. Control when held down.
    # {Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL]
    # To use this example, you can't remap capslock with define_modmap.
)

# [Conditional multipurpose modmap] Multipurpose modmap in certain conditions,
# such as for a particular device.
define_conditional_multipurpose_modmap(lambda wm_class, device_name: device_name.startswith("Microsoft"), {
   # Left shift is open paren when pressed and released.
   # Left shift when held down.
   Key.LEFT_SHIFT: [Key.KPLEFTPAREN, Key.LEFT_SHIFT],

   # Right shift is close paren when pressed and released.
   # Right shift when held down.
   Key.RIGHT_SHIFT: [Key.KPRIGHTPAREN, Key.RIGHT_SHIFT]
})


# Keybindings for Firefox/Chrome
define_keymap(re.compile("Firefox|Google-chrome"), {
    K("Super-a"): [K("C-home"), K("C-a"), set_mark(True)],
    K("Super-c"): [K("C-c"), set_mark(False)],
    K("Super-v"): [K("C-v"), set_mark(False)],
    K("Super-z"): [K("C-z"), set_mark(False)],
}, "Firefox and Chrome")

# Emacs-like keybindings in non-Emacs applications
define_keymap(lambda wm_class: wm_class not in ("Emacs", "URxvt", "Gnome-terminal", "Hyper"), {
    K("Super-a"): [K("C-home"), K("C-a"), set_mark(True)],
    K("Super-c"): [K("C-c"), set_mark(False)],
    K("Super-v"): [K("C-v"), set_mark(False)],
    K("Super-z"): [K("C-z"), set_mark(False)],
    K("Super-o"): K("C-o"),
    K("Super-s"): K("C-s"),
    # Cursor
    K("C-b"): with_mark(K("left")),
    K("C-f"): with_mark(K("right")),
    K("C-p"): with_mark(K("up")),
    K("C-n"): with_mark(K("down")),
    K("C-h"): with_mark(K("backspace")),
    # Forward/Backward word
    K("M-b"): with_mark(K("C-left")),
    K("M-f"): with_mark(K("C-right")),
    # Beginning/End of line
    K("C-a"): with_mark(K("home")),
    K("C-e"): with_mark(K("end")),
    # Page up/down
    K("M-v"): with_mark(K("page_up")),
    K("C-v"): with_mark(K("page_down")),
    # Beginning/End of file
    K("M-Shift-comma"): with_mark(K("C-home")),
    K("M-Shift-dot"): with_mark(K("C-end")),
    # Newline
    K("C-m"): K("enter"),
    # Copy
    K("C-w"): [K("C-x"), set_mark(False)],
    K("M-w"): [K("C-c"), set_mark(False)],
    K("C-y"): [K("C-v"), set_mark(False)],
    # Delete
    K("C-d"): [K("delete"), set_mark(False)],
    K("M-d"): [K("C-delete"), set_mark(False)],
    # Kill line
    K("C-k"): [K("Shift-end"), K("C-x"), set_mark(False)],
    # Undo
    K("C-slash"): [K("C-z"), set_mark(False)],
    K("C-Shift-ro"): K("C-z"),
    # Mark
    K("C-space"): set_mark(True),
    K("C-M-space"): with_or_set_mark(K("C-right")),
    # Search
    K("C-s"): K("F3"),
    K("C-r"): K("Shift-F3"),
    K("M-Shift-key_5"): K("C-h"),
    # Cancel
    K("C-g"): [K("esc"), set_mark(False)],
}, "Emacs-like keys")

define_keymap(lambda wm_class: wm_class in ("Gnome-terminal"), {
    K("Super-c"): [K("C-c"), set_mark(False)],
    K("Super-v"): [K("C-v"), set_mark(False)],
    K("Super-z"): [K("C-z"), set_mark(False)],
}, "win-like keys")

define_keymap(lambda wm_class: wm_class in ("Hyper"), {
    K("Super-c"): [K("C-Shift-c"), set_mark(False)],
    K("Super-v"): [K("C-Shift-v"), set_mark(False)],
    K("Super-z"): [K("C-Shift-z"), set_mark(False)],
    K("Super-t"): [K("C-Shift-t"), set_mark(False)],
}, "Hyper-mac-like keys")

define_keymap(lambda wm_class: wm_class in ("Emacs"), {
    K("M-Tab"): [K("Super-Tab"), set_mark(False)],
    K("M-Space"): [K("Super-Space"), set_mark(False)],
}, "Emacs-mac-like keys")

define_keymap(lambda wm_class: wm_class in ("Slack"), {
    K("Super-k"): [K("C-k"), set_mark(False)],
    K("Super-k"): [K("C-k"), set_mark(False)],
    K("Super-g"): [K("C-g"), set_mark(False)],
    K("Super-f"): [K("C-f"), set_mark(False)],
    K("Super-Enter"): [K("C-Enter"), set_mark(False)],
    K("Super-Shift-a"): [K("C-Shift-a"), set_mark(False)],
}, "slack-mac-like keys")
