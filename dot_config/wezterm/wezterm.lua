local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local LEFT_HARD_DIVIDER = wezterm.nerdfonts.pl_left_hard_divider
local LEFT_SOFT_DIVIDER = wezterm.nerdfonts.pl_left_soft_divider
local RIGHT_HARD_DIVIDER = wezterm.nerdfonts.pl_right_hard_divider

local BASE_00 = "#282c34"
local BASE_01 = "#353b45"
local BASE_02 = "#3e4451"
local BASE_03 = "#545862"
local BASE_04 = "#565c64"
local BASE_05 = "#abb2bf"
local BASE_06 = "#b6bdca"
local BASE_07 = "#c8ccd4"
local BASE_08 = "#e06c75"
local BASE_09 = "#d19a66"
local BASE_0A = "#e5c07b"
local BASE_0B = "#98c379"
local BASE_0C = "#56b6c2"
local BASE_0D = "#61afef"
local BASE_0E = "#c678dd"
local BASE_0F = "#be5046"

local TAB_BACKGROUND = BASE_00
local TAB_FOREGROUND = BASE_05

config.colors = {
    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = TAB_BACKGROUND,
        new_tab = {
            bg_color = TAB_BACKGROUND,
            fg_color = TAB_FOREGROUND
        },
        new_tab_hover = {
            bg_color = TAB_BACKGROUND,
            fg_color = TAB_FOREGROUND,
            italic = true
        }
    }
}
config.color_scheme = 'OneDark (base16)'
config.debug_key_events = true
config.disable_default_key_bindings = true
config.enable_scroll_bar = true
config.font = wezterm.font('UbuntuMono Nerd Font Mono')
config.font_size = 17.0
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 100000
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
-- config.window_decorations = 'RESIZE'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

config.keys = {{
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1)
}, {
    key = 'Tab',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(1)
}, {
    key = 'Tab',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ActivateTabRelative(-1)
}, {
    key = 'Tab',
    mods = 'SHIFT|CMD',
    action = wezterm.action.ActivateTabRelative(-1)
}, {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendKey {
        key = 'Enter',
        mods = 'ALT'
    }
}, {
    key = 'c',
    mods = 'SHIFT|CMD',
    action = wezterm.action.CopyTo('ClipboardAndPrimarySelection')
}, {
    key = 'f',
    mods = 'SHIFT|CMD',
    -- When CaseInSensitiveString is empty, Wezterm retains the previous search pattern. This is a
    -- bug that is yet to be fixed: https://github.com/wez/wezterm/issues/1988
    action = wezterm.action.Search {
        CaseInSensitiveString = ""
    }
}, {
    key = 'n',
    mods = 'SHIFT|CMD',
    action = wezterm.action.SpawnWindow
}, {
    key = 'p',
    mods = 'SHIFT|CMD',
    action = wezterm.action.ActivateCommandPalette
}, {
    key = 't',
    mods = 'SHIFT|CMD',
    action = wezterm.action.SpawnTab('CurrentPaneDomain')
}, {
    key = 'v',
    mods = 'SHIFT|CMD',
    action = wezterm.action.PasteFrom('Clipboard')
}, {
    key = 'w',
    mods = 'SHIFT|CMD',
    action = wezterm.action.CloseCurrentTab {
        confirm = true
    }
}}

for key = string.byte("a"), string.byte("z") do
    local key = string.char(key)
    table.insert(config.keys, {
        key = key,
        mods = 'CMD',
        action = wezterm.action.SendKey {
            key = key,
            mods = 'CTRL'
        }
    })
end

-- https://wezfurlong.org/wezterm/config/mouse.html#configuring-mouse-assignments
config.mouse_bindings = {{
    -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
    event = {
        Up = {
            streak = 1,
            button = 'Left'
        }
    },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'
}, {
    -- Bind the 'Up' event of ctrl-click to open hyperlinks
    event = {
        Up = {
            streak = 1,
            button = 'Left'
        }
    },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor
}, {
    -- Disable the 'Down' event of ctrl-click to avoid weird program behaviors
    event = {
        Down = {
            streak = 1,
            button = 'Left'
        }
    },
    mods = 'CTRL',
    action = wezterm.action.Nop
}, {
    -- Bind the 'Up' event of cmd-click to open hyperlinks
    event = {
        Up = {
            streak = 1,
            button = 'Left'
        }
    },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor
}, {
    -- Disable the 'Down' event of cmd-click to avoid weird program behaviors
    event = {
        Down = {
            streak = 1,
            button = 'Left'
        }
    },
    mods = 'CMD',
    action = wezterm.action.Nop
}}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    -- If the tab title is explicitly set, take that.
    local title = tab.tab_title
    if not title or #title == 0 then
        -- Otherwise, use the title from the active pane in that tab.
        title = tab.active_pane.title
    end

    -- Add tab index to the title
    title = tab.tab_index .. ":" .. title

    -- Ensure that the titles fit in the available space, and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 3)

    local ACTIVE_BACKGROUND = BASE_0B
    local INACTIVE_BACKGROUND = BASE_02
    local ACTIVE_FOREGROUND = BASE_02
    local INACTIVE_FOREGROUND = BASE_05

    local next_tab = tabs[tab.tab_index + 2]
    local foreground = nil
    local background = nil
    local arrow = nil
    local arrow_foreground = nil
    local arrow_background = nil

    if tab.is_active then
        foreground = ACTIVE_FOREGROUND
        background = ACTIVE_BACKGROUND
        arrow = LEFT_HARD_DIVIDER
        arrow_foreground = ACTIVE_BACKGROUND
        if next_tab then
            arrow_background = INACTIVE_BACKGROUND
        else
            arrow_background = TAB_BACKGROUND
        end
    else
        foreground = INACTIVE_FOREGROUND
        background = INACTIVE_BACKGROUND
        if next_tab then
            if next_tab.is_active then
                arrow = LEFT_HARD_DIVIDER
                arrow_foreground = INACTIVE_BACKGROUND
                arrow_background = ACTIVE_BACKGROUND
            else
                arrow = LEFT_SOFT_DIVIDER
                arrow_foreground = INACTIVE_FOREGROUND
                arrow_background = INACTIVE_BACKGROUND
            end
        else
            arrow = LEFT_HARD_DIVIDER
            arrow_foreground = INACTIVE_BACKGROUND
            arrow_background = TAB_BACKGROUND
        end
    end

    return {{
        Foreground = {
            Color = foreground
        }
    }, {
        Background = {
            Color = background
        }
    }, {
        Text = " " .. title .. " "
    }, {
        Foreground = {
            Color = arrow_foreground
        }
    }, {
        Background = {
            Color = arrow_background
        }
    }, {
        Text = arrow
    }}
end)

return config
