(pcall :require "luarocks.loader")

(local gears     (require :gears))
(local beautiful (require :beautiful))
(local awful     (require :awful))
(local naughty   (require :naughty))
(local hotkeys_popup (require :awful.hotkeys_popup))
(local wibox     (require :wibox))
(local menubar   (require :menubar))

(fn initialize []
  ;; Error handling
  ;; Check if awesome encountered an error during startup and fell back to
  ;; another config (This code will only ever execute for the fallback config)
  (let [preset { :timeout 0 :bg "#000000" :fg "#ff0000" :max_height 1080 }]
    (when awesome.startup_errors
      (naughty.notify {:preset preset
                       :title "Oops, there were errors during startup!"
                       :text awesome.startup_errors}))

    (var in-error false)
    (awesome.connect_signal
     "debug::error"
     (fn [err]
       ;; Make sure we don't go into an endless error loop
       (when (not in-error)
         (set in-error true)
         (naughty.notify {:preset preset
                          :title "Oops, an error happened!"
                          :text (tostring err)})
         (naughty.notify {:preset preset
                          :title "Oops, an error happened!"
                          :text (tostring err)})
         (set in-error false))))))

(initialize)
(require :awful.hotkeys_popup.keys)
(require :keybinds)
(require :awful.remote)

;; This is used later as the default terminal and editor to run.
(local terminal "alacritty")
(local editor "emacsclient -c")
(local editor_cmd editor)
(local modkey "Mod4")
(local appmodkey "Mod1")
(set customization {})
(set customization.gap 2)

;; Themes define colours, icons, font and wallpapers.
(beautiful.init (.. (gears.filesystem.get_configuration_dir) "theme.lua"))

(set beautiful.useless_gap customization.gap)

(local mykeyboardlayout (awful.widget.keyboardlayout))

(local mytextclock (wibox.widget.textclock))

(local taglist_buttons
       (gears.table.join
        (awful.button [] 1 (fn [t] (t:view_only)))
        (awful.button [ modkey ] 1 (fn [t] (if client.focus (client.focus:move_to_tag t))))

        (awful.button [] 3 awful.tag.viewtoggle)
        (awful.button [ modkey ] 3 (fn [t] (if client.focus (client.focus:toggle_tag t))))

        (awful.button [] 4 (fn [t] (awful.tag.viewnext t.screen)))
        (awful.button [] 5 (fn [t] (awful.tag.viewprev t.screen)))
	))

(local tasklist_buttons
       (gears.table.join
	(awful.button [] 1 (fn [c]
			     (if (= c client.focus)
				 (set c.minimized true)
				 (c:emit_signal "request::activate"
						"tasklist"
						{ :raise true }))))
	(awful.button [] 3 (fn [] (awful.menu.client_list { :theme { :width 250 } })))
	(awful.button [] 4 (fn [] (awful.client.focus.byidx 1)))
	(awful.button [] 5 (fn [] (awful.client.focus.byidx -1)))
	))

(set awful.layout.layouts
     [ awful.layout.suit.tile
       awful.layout.suit.max
       awful.layout.suit.max.fullscreen
       awful.layout.suit.floating ])

(fn set_wallpaper [s]
  (when beautiful.wallpaper
    (var wallpaper beautiful.wallpaper)
    (when (= (type wallpaper) "function")
      (set wallpaper (wallpaper s)))
    (gears.wallpaper.maximized wallpaper s true)))

(screen.connect_signal "property::geometry" set_wallpaper)

(awful.screen.connect_for_each_screen
 (fn [s]
   (set_wallpaper s)
   (awful.tag ["mus" "dev" "sys" "www" "vbox" "chat" "vid" "gfx" "config"] s (. awful.layout.layouts 1))
   (set s.mypromptbox (awful.widget.prompt))
   (set s.mylayoutbox (awful.widget.layoutbox s))
   (s.mylayoutbox:buttons
    (gears.table.join
     (awful.button [] 1 (fn [] (awful.layout.inc 1)))
     (awful.button [] 3 (fn [] (awful.layout.inc -1)))
     (awful.button [] 4 (fn [] (awful.layout.inc 1)))
     (awful.button [] 5 (fn [] (awful.layout.inc -1)))
     ))
   (set s.mytaglist (awful.widget.taglist
		     { :screen s
		       :filter awful.widget.taglist.filter.all
		       :buttons taglist_buttons }))
   (set s.mytasklist (awful.widget.tasklist
	 	      { :screen s
	 	        :filter awful.widget.taglist.filter.currenttags
	 	        :buttons tasklist_buttons }))

   (set s.mywibox (awful.wibar { :position "top" :screen s }))
   (s.mywibox:setup
    {
     :layout wibox.layout.align.horizontal
     1 {
	:layout wibox.layout.fixed.horizontal
	1 s.mytaglist
	2 s.mypromptbox
	}
     2 s.mytasklist
     3 {
	:layout wibox.layout.fixed.horizontal
	1 (awful.widget.watch "bash -c \"~/.config/awesome/player-status.sh\"" 3)
	2 (wibox.widget.textbox " | ")
        3 mykeyboardlayout
	4 (wibox.widget.textbox " | ")
        5 (wibox.widget.systray)
	6 (wibox.widget.textbox " | ")
        7 mytextclock
	}
     })
   ))

(root.buttons
  (gears.table.join
    (awful.button [] 3 (fn [] (mymainmenu:toggle)))
    (awful.button [] 4 awful.tag.viewnext)
    (awful.button [] 5 awful.tag.viewprev)
    ))

(set awful.rules.rules
     [
      ;; All clients will match this rule.
      {
        :rule []
        :properties {
          :border_width beautiful.border_width
          :border_color beautiful.border_normal
          :focus awful.client.focus.filter
          :raise true
          :keys clientkeys
          :buttons clientbuttons
          :screen awful.screen.preferred
          :placement (+ awful.placement.no_overlap awful.placement.no_offscreen)
        }

	;; Floating clients.
	{
	  :rule_any {
            :instance [
              "DTA"    ; Firefox addon DownThemAll.
	      "copyq"  ; Includes session name in class.
              "pinentry"
            ]
            :class [
              "Arandr"
              "Blueman-manager"
              "Gpick"
              "Kruler"
              "MessageWin"    ; kalarm.
              "Sxiv"
              "Tor Browser"   ; Needs a fixed window size to avoid fingerprinting by screen size.
              "Wpa_gui"
              "veromix"
              "xtightvncviewer"
	    ]

	    ;; Note that the name property shown in xprop might be set slightly
	    ;; after creation of the client and the name shown there might not
	    ;; match defined rules here.
            :name [
              "Event Tester"   ; xev.
            ]
            :role [
              "AlarmWindow"    ; Thunderbird's calendar.
              "ConfigManager"  ; Thunderbird's about:config.
              "pop-up"         ; e.g. Google Chrome's (detached) Developer Tools.
            ]
          }
	  :properties { :floating true }
	}

        ;; Add titlebars to normal clients and dialogs
        {
	  :rule_any { :type [ "normal" "dialog" ] }
	  :properties { :titlebars_enabled true }
	}
      }

      ;; Set Firefox to always map on the tag named "2" on screen 1.
      ;; { rule = { class = "Firefox" },
      ;;   properties = { screen = 1, tag = "2" } },

      { :rule { :instance "Calendar" }
        :properties {
	             :floating true
	             :placement awful.placement.centered
                     }
        }

      { :rule { :class "emacs" }
        :properties {
                     :size_hints_honor false
                     }
        }

      { :rule { :instance "New-Note" }
        :properties {
	             :floating true
	             :placement awful.placement.centered
                     }
        }
      ])

(client.connect_signal
  "manage"
  (fn [c]
    ;; Set the windows at the slave,
    ;; i.e. put it at the end of others instead of setting it master.
    ;; if not awesome.startup then awful.client.setslave(c) end
    (when (and awesome.startup
	       (not c.size_hints.user_position)
	       (not c.size_hints.program_position))
      ;; Prevent clients from being unreachable after screen count changes.
      (awful.placement.no_offscreen c))))

;; Add a titlebar if titlebars_enabled is set to true in the rules.
(client.connect_signal
  "request::titlebars"
  (fn [c]
    ;; buttons for the titlebar
    (local buttons (gears.table.join
        (awful.button [ ] 1 (fn []
            (c:emit_signal "request::activate" "titlebar" { :raise true })
            (awful.mouse.client.move c)))
        (awful.button [ ] 3 (fn []
            (c:emit_signal "request::activate" "titlebar" { :raise true })
            (awful.mouse.client.resize c)))))

    (let [tb (awful.titlebar c)]
      (set tb.widget [
          { ; Left
              1 (awful.titlebar.widget.iconwidget c)
              :buttons buttons
              :layout  wibox.layout.fixed.horizontal
          }
          { ; Middle
              1 { ; Title
                  :align  "center"
                  :widget (awful.titlebar.widget.titlewidget c)
              }
              :buttons buttons
              :layout  wibox.layout.flex.horizontal
          }
          { ; Right
              :layout (wibox.layout.fixed.horizontal)
              1 (awful.titlebar.widget.floatingbutton  c)
              2 (awful.titlebar.widget.maximizedbutton c)
              3 (awful.titlebar.widget.stickybutton    c)
              4 (awful.titlebar.widget.ontopbutton     c)
              5 (awful.titlebar.widget.closebutton     c)
          }
          :layout wibox.layout.align.horizontal
        ]))))

(client.connect_signal "mouse::enter" (fn [c]
			 (c:emit_signal "request::activate" "mouse_enter" { :raise false })))
(client.connect_signal "focus"   (fn [c] (set c.border_color beautiful.border_focus)))
(client.connect_signal "unfocus" (fn [c] (set c.border_color beautiful.border_normal)))
