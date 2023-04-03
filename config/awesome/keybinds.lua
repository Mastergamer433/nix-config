local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local wibox = require("wibox")
local menubar = require("menubar")
require("awful.hotkeys_popup.keys")
local appmodkey = "Mod1"
local modkey = "Mod4"
local globalkeys
local function _1_()
  return awful.spawn("emacsclient -c")
end
local function _2_()
  return awful.spawn("flameshot gui")
end
local function _3_()
  return awful.spawn("emacsclient -e \"(keo/org-agenda)\"")
end
local function _4_()
  return awful.spawn("emacsclient -e \"(keo/awesomewm-denote-new-note)\"")
end
local function _5_()
  return awful.spawn("alacritty")
end
local function _6_()
  return awful.spawn("slock")
end
local function _7_()
  return awful.client.focus.global_bydirection("down")
end
local function _8_()
  return awful.client.focus.global_bydirection("up")
end
local function _9_()
  return awful.client.focus.global_bydirection("left")
end
local function _10_()
  return awful.client.focus.global_bydirection("right")
end
local function _11_()
  return awful.client.swap.global_bydirection("down")
end
local function _12_()
  return awful.client.swap.global_bydirection("up")
end
local function _13_()
  return awful.client.swap.global_bydirection("left")
end
local function _14_()
  return awful.client.swap.global_bydirection("right")
end
local function _15_()
  return awful.screen.focus_relative(1)
end
local function _16_()
  return awful.screen.focus_relative(-1)
end
local function _17_()
  return awful.spawn(terminal)
end
local function _18_()
  return awful.tag.incnmaster(1, nil, true)
end
local function _19_()
  return awful.tag.incnmaster(-1, nil, true)
end
local function _20_()
  return awful.tag.incncol(1, nil, true)
end
local function _21_()
  return awful.tag.incncol(-1, nil, true)
end
local function _22_()
  local s = awful.screen.focused()
  return (s.mypromptbox):run()
end
local function _23_()
  return menubar.show()
end
globalkeys = gears.table.join(awful.key({appmodkey}, "e", _1_, {description = "open emacsclient", group = "application"}), awful.key({appmodkey}, "s", _2_, {description = "take screenshot", group = "application"}), awful.key({appmodkey}, "c", _3_, {description = "open calendar in emacsclient", group = "application"}), awful.key({appmodkey}, "n", _4_, {description = "create a new denote enry in emacsclient", group = "application"}), awful.key({modkey}, "Return", _5_, {description = "open a terminal", group = "application"}), awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}), awful.key({modkey}, "t", _6_, {description = "lock screen", group = "awesome"}), awful.key({modkey}, "j", _7_, {description = "focus down", group = "client"}), awful.key({modkey}, "k", _8_, {description = "focus up", group = "client"}), awful.key({modkey}, "h", _9_, {description = "focus left", group = "client"}), awful.key({modkey}, "l", _10_, {description = "focus right", group = "client"}), awful.key({modkey, "Shift"}, "j", _11_, {description = "swap down", group = "client"}), awful.key({modkey, "Shift"}, "k", _12_, {description = "swap up", group = "client"}), awful.key({modkey, "Shift"}, "h", _13_, {description = "swap left", group = "client"}), awful.key({modkey, "Shift"}, "l", _14_, {description = "swap right", group = "client"}), awful.key({modkey, "Control"}, "j", _15_, {description = "focus the next screen", group = "screen"}), awful.key({modkey, "Control"}, "k", _16_, {description = "focus the previous screen", group = "screen"}), awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}), awful.key({modkey}, "Return", _17_, {description = "open a terminal", group = "launcher"}), awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}), awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}), awful.key({modkey, "Control", "Shift"}, "h", _18_, {description = "increase the number of master clients", group = "layout"}), awful.key({modkey, "Control", "Shift"}, "l", _19_, {description = "decrease the number of master clients", group = "layout"}), awful.key({modkey, "Control"}, "h", _20_, {description = "increase the number of columns", group = "layout"}), awful.key({modkey, "Control"}, "l", _21_, {description = "decrease the number of columns", group = "layout"}), awful.key({modkey}, "r", _22_, {description = "run prompt", group = "launcher"}), awful.key({modkey}, "p", _23_, {description = "show menubar", group = "launcher"}))
local function _24_(c)
  c.fullscreen = not c.fullscreen
  return c:raise()
end
local function _25_(c)
  return c:kill()
end
local function _26_(c)
  return c:swap(awful.client.getmaster())
end
local function _27_(c)
  return c:move_to_screen()
end
local function _28_(c)
  c.ontop = not c.ontop
  return nil
end
clientkeys = gears.table.join(awful.key({modkey}, "f", _24_, {description = "toggle fullscreen", group = "client"}), awful.key({modkey}, "q", _25_, {description = "close", group = "client"}), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {description = "toggle floating", group = "client"}), awful.key({modkey, "Control"}, "Return", _26_, {description = "move to master", group = "client"}), awful.key({modkey}, "o", _27_, {description = "move to screen", group = "client"}), awful.key({modkey}, "t", _28_, {description = "toggle keep on top", group = "client"}))
for i = 1, 9 do
  local function _29_()
    local scr = awful.screen.focused()
    local tag = scr.tags[i]
    if tag then
      return tag:view_only()
    else
      return nil
    end
  end
  local function _31_()
    local scr = awful.screen.focused()
    local tag = scr.tags[i]
    if tag then
      return awful.tag.viewtoggle(tag)
    else
      return nil
    end
  end
  local function _33_()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        return (client.focus):move_to_tag(tag)
      else
        return nil
      end
    else
      return nil
    end
  end
  local function _36_()
    if client.focus then
      local tag = client.focus.screen.tags(i)
      if tag then
        return (client.focus):toggle_tag(tag)
      else
        return nil
      end
    else
      return nil
    end
  end
  globalkeys = gears.table.join(globalkeys, awful.key({modkey}, ("#" .. (i + 9)), _29_, {description = ("view tag #" .. i), group = "tag"}), awful.key({modkey, "Control"}, ("#" .. (i + 9)), _31_, {description = ("toggle tag #" .. i), group = "tag"}), awful.key({modkey, "Shift"}, ("#" .. (i + 9)), _33_, {description = ("move focused client to tag #" .. i), group = "tag"}), awful.key({modkey, "Control", "Shift"}, ("#" .. (i + 9)), _36_, {description = ("toggle focused client on tag #" .. i), group = "tag"}))
end
local clientbuttons
local function _39_(c)
  return c:emit_signal("request::activate", "mouse_click", {raise = true})
end
local function _40_(c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  return awful.mouse.client.move(c)
end
local function _41_(c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  return awful.mouse.client.resize(c)
end
clientbuttons = gears.table.join(awful.button({}, 1, _39_), awful.button({modkey}, 1, _40_), awful.button({modkey}, 3, _41_))
return root.keys(globalkeys)
