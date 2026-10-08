-- ----- Monitors -----

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- Sometimes it has number 1, sometimes 4, idk
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@119.98", position = "auto", scale = 1 })
hl.monitor({ output = "HDMI-A-4", mode = "1920x1080@119.98", position = "auto", scale = 1 })

-- Trigger when the switch is toggled
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("swaylock -f; hyprctl dispatch dpm off")) -- lock
-- Trigger when the switch is turning on
-- bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, preferred, auto, auto"
-- Trigger when the switch is turning off
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"))

-- ----- Init -----

-- Execute your favorite apps at launch
-- Status bar & wallpaper & notification daemon
-- exec-once = wl-paste -p --watch wl-copy -pc -- & waybar & hyprpaper

-- Execute on config reload
-- Doesn't work idk why
-- exec = killall -q .waybar-wrapped hyprpaper ; waybar & hyprpaper &

-- Source a file (multi-file configs)
require("~/.config/hypr/myColors.conf")

-- Some default env vars.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

-- ----- Input -----

hl.config({
  input = {
    kb_layout = "us,ru",
    kb_variant = "",
    kb_model = "",
    kb_options = "grp:alt_shift_toggle",
    kb_rules = "",

    repeat_rate = 25, -- Repeats for held down keys per second
    repeat_delay = 600, -- In ms

    follow_mouse = 1,

    touchpad = {
      disable_while_typing = false,

      tap_to_click = true,
      drag_lock = true,
      clickfinger_behavior = true,

      scroll_factor = 1.0,
      natural_scroll = true,
    },

    sensitivity = 0.0, -- Mouse sensitivity: -1.0..1.0, 0 means no modification.
    scroll_method = "2fg",
  },
})

hl.device({
  name = "logitech-usb-optical-mouse",
  sensitivity = -0.9,
})
hl.device({
  name = "a4tech-usb-mouse",
  sensitivity = -0.9,
})

-- ----- Misc -----

hl.config({
  misc = {
    always_follow_on_dnd = true, -- Follow mouse on drag and drop
    focus_on_activate = false, -- Whether to focus an app that requests to be focused
    mouse_move_focuses_monitor = true,
    animate_manual_resizes = true,
    disable_autoreload = true, -- Doesn't autoreload with home-manager anyway

    mouse_move_enables_dpms = true,
    key_press_enables_dpms = false,
  },
})

-- ----- General -----

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,

    col = {
      active_border = 0x46a6b2ee,
      inactive_border = 0x636c6eaa,
    },

    layout = "dwindle",
  },
  cursor = {
    inactive_timeout = 1,
    no_warps = true,
    no_hardware_cursors = 1,
  },
})


-- ----- Decoration -----

hl.config({
  decoration = {
    rounding = 10,

    active_opacity = 0.95,
    inactive_opacity = 0.85,
    fullscreen_opacity = 1.0,

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      new_optimizations = true,
    }

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0x1a1a1aee,
    },

    dim_inactive = false,
    dim_strength = 0.1,
  },
})

-- ----- Animations -----

hl.config({
  animations = {
    enabled = true,
  },
})
hl.animation({ leaf = "windows", enabled = true, speed = 3 })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10 })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8 })
hl.animation({ leaf = "fade", enabled = true, speed = 7 })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3 })

-- ----- Layout -----

hl.config({
  dwindle = {
    preserve_split = bool, -- you probably want this
  },
  master = {
    -- new_is_master = true,
  },
})

-- ----- Window Rules -----

hl.window_rule({
  match = { class = "firefox" },
  opacity = "1.0",
})


-- ----- Layer Rules -----

hl.layer_rule({
  match = { namespace = "background" },
  blur = true,
})


-- ----- Binds -----

hl.config({
  binds = {
    workspace_back_and_forth = false, -- Switching to the currently focused workspace will instead switch to the previous workspace
    allow_workspace_cycles = true, -- Workspaces don’t forget their previous workspace
    focus_preferred_method = 0, -- 0 - history. 1 - edge length
    drag_threshold = 10 -- Fire a drag event only after dragging for more than 10px
  }
})

-- $mainMod = SUPER
-- $moveMod = SHIFT -- Key to move windows/workspaces
-- $resizeMod = ALT -- Key to resize windows
-- $groupMod = CTRL -- Key to manage groups

hl.bind("SUPER + Q", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + X", hl.dsp.exit())
hl.bind("SUPER + Space", hl.dsp.exec_cmd("rofi -show drun")) -- select app
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("swaylock -f; hyprctl dispatch dpms off")) -- lock
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")) -- screenshot
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprpicker --autocopy --format=hex")) -- pick color from screen

-- Window layout
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + S", hl.dsp.window.center({ }))
hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" })) -- pin active window (shows on all workspaces)
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) -- Fullscreen
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- Fullscreen with gaps and bars
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = -1, client = 2, action = "toggle" })) -- Fake fullscreen
hl.bind("SUPER + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" })) -- Toggle window opacity

-- Move tiled window
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Move floating window
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ relative = true, x = -50, y = 0 }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ relative = true, x = 0, y = 50 }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ relative = true, x = 0, y = -50 }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ relative = true, x = 50, y = 0 }))

-- Move active window to a workspace
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize window
hl.bind("SUPER + ALT + H", hl.dsp.window.resize({ relative = true, x = -50, y = 0 }))
hl.bind("SUPER + ALT + J", hl.dsp.window.resize({ relative = true, x = 0, y = 50 }))
hl.bind("SUPER + ALT + K", hl.dsp.window.resize({ relative = true, x = 0, y = -50 }))
hl.bind("SUPER + ALT + L", hl.dsp.window.resize({ relative = true, x = 50, y = 0 }))
-- bind = $mainMod $resizeMod, equal, splitratio, exact 1.0 -- equal ratio

-- Focus window
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next())
hl.bind("SUPER + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next()) -- change focus to another window
  hl.dispatch(hl.dsp.window.bring_to_top()) -- bring it to the top
end)

-- Group
-- bind = $mainMod, G, togglegroup, -- toggle
-- bind = $mainMod $groupMod $moveMod, space, moveoutofgroup -- move out of group
-- bind = $mainMod $groupMod, h, changegroupactive, b -- move left
-- bind = $mainMod $groupMod, l, changegroupactive, f -- move right
-- bind = $mainMod $groupMod $moveMod, h, moveintogroup, l -- move into group left
-- bind = $mainMod $groupMod $moveMod, j, moveintogroup, d -- move into group down
-- bind = $mainMod $groupMod $moveMod, k, moveintogroup, u -- move into group up
-- bind = $mainMod $groupMod $moveMod, l, moveintogroup, r -- move into group right

-- Focus workspace
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Scroll through existing workspaces on current monitor with mainMod + scroll/[]
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + bracketleft", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + bracketright", hl.dsp.focus({ workspace = "m-1" }))

-- Move to the previous workspace
-- bind = $mainMod, x, workspace, previous

-- Focus monitor
hl.bind("SUPER + W", hl.dsp.focus({ monitor = "left" }))
hl.bind("SUPER + E", hl.dsp.focus({ monitor = "right" }))

-- Move active workspace to a monitor
hl.bind("SUPER + SHIFT + W", hl.dsp.workspace.move({ monitor = "left" }))
hl.bind("SUPER + SHIFT + E", hl.dsp.workspace.move({ monitor = "right" }))

-- Move cursor
hl.bind("SUPER + period", hl.dsp.cursor.move_to_corner({ corner = 0 })) -- bottom left

-- Raise volume on press, volume limited to 150%
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))

-- Lower volume that will activate even while an input inhibitor is active
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))

-- Gestures
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

