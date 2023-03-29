(local gears     (require :gears))
(local beautiful (require :beautiful))
(local awful     (require :awful))
(local naughty   (require :naughty))
(local hotkeys_popup (require :awful.hotkeys_popup))
(local wibox     (require :wibox))
(local menubar   (require :menubar))
(require :awful.hotkeys_popup.keys)

(local appmodkey "Mod1")
(local modkey "Mod4")
(var globalkeys
     (gears.table.join
      ;; My application key bindings
      (awful.key [ appmodkey ] "e" (fn [] (awful.spawn "emacsclient -c"))
                 { :description "open emacsclient" :group "application"})
      (awful.key [ appmodkey ] "s" (fn [] (awful.spawn "flameshot gui"))
                 { :description "take screenshot" :group "application"})
      (awful.key [ appmodkey ] "c" (fn [] (awful.spawn "emacsclient -e \"(keo/org-agenda)\""))
                 { :description "open calendar in emacsclient" :group "application"})
      (awful.key [ appmodkey ] "n" (fn [] (awful.spawn "emacsclient -e \"(keo/awesomewm-denote-new-note)\""))
                 { :description "create a new denote enry in emacsclient" :group "application" })
      (awful.key [ modkey ] "s" hotkeys_popup.show_help
                 { :description "show help" :group "awesome" })
      (awful.key [ modkey ] "t" (fn [] (awful.spawn "slock"))
                 { :description "lock screen" :group "awesome" })
      (awful.key [ modkey ] "j"
                 (fn []
	           (awful.client.focus.global_bydirection "down"))
                 { :description "focus down" :group "client" })
      (awful.key [ modkey ] "k"
                 (fn []
	           (awful.client.focus.global_bydirection "up"))
                 { :description "focus up" :group "client" })
      (awful.key [ modkey ] "h" 
                 (fn []
	           (awful.client.focus.global_bydirection "left"))
                 { :description "focus left" :group "client" })
      (awful.key [ modkey ] "l"
                 (fn []
	           (awful.client.focus.global_bydirection "right"))
                 { :description "focus right" :group "client" })
      (awful.key [ modkey "Shift" ] "j"
                 (fn []
	           (awful.client.swap.global_bydirection "down"))
                 { :description "swap down" :group "client" })
      (awful.key [ modkey "Shift" ] "k"
                 (fn []
	           (awful.client.swap.global_bydirection "up"))
                 { :description "swap up" :group "client" })
      (awful.key [ modkey "Shift" ] "h" 
                 (fn []
	           (awful.client.swap.global_bydirection "left"))
                 { :description "swap left" :group "client" })
      (awful.key [ modkey "Shift" ] "l"
                 (fn []
	           (awful.client.swap.global_bydirection "right"))
                 { :description "swap right" :group "client" })
      (awful.key [ modkey "Control" ] "j" (fn [] (awful.screen.focus_relative 1))
                 { :description "focus the next screen" :group "screen" })
      (awful.key [ modkey "Control" ] "k" (fn [] (awful.screen.focus_relative -1))
                 { :description "focus the previous screen" :group "screen" })
      (awful.key [ modkey ] "u" awful.client.urgent.jumpto
                 { :description "jump to urgent client" :group "client" })
      (awful.key [ modkey ] "Return" (fn [] (awful.spawn terminal))
                 { :description "open a terminal" :group "launcher" })
      (awful.key [ modkey "Control" ] "r"  awesome.restart
                 { :description "reload awesome" :group "awesome" })
      (awful.key [ modkey "Shift" ] "q" awesome.quit
                 { :description "quit awesome" :group "awesome"})
      (awful.key [ modkey "Control" "Shift" ] "h" (fn [] (awful.tag.incnmaster 1 nil true))
                 { :description "increase the number of master clients" :group "layout"})
      (awful.key [ modkey "Control" "Shift" ] "l" (fn [] (awful.tag.incnmaster -1 nil true))
                 { :description "decrease the number of master clients" :group "layout"})
      (awful.key [ modkey "Control" ] "h" (fn [] (awful.tag.incncol 1 nil true))
                 { :description "increase the number of columns" :group "layout"})
      (awful.key [ modkey "Control" ] "l" (fn [] (awful.tag.incncol -1 nil true))
                 { :description "decrease the number of columns" :group "layout"})
      (awful.key [ modkey ] "r"
	         (fn []
		   (let [s (awful.screen.focused)]
		     (s.mypromptbox:run)))
                 { :description "run prompt" :group "launcher" })
      (awful.key [ modkey ] "p" (fn [] (menubar.show))
                 { :description "show menubar" :group "launcher" })))

(local clientkeys
       (gears.table.join
	 (awful.key [ modkey ] "f"
		    (fn [c]
			(set c.fullscreen (not c.fullscreen))
			(c:raise))
		    { :description "toggle fullscreen" :group "client" })
	 (awful.key [ modkey ] "q" (fn [c] (c:kill))
		    { :description "close" :group "client" })
	 (awful.key [ modkey "Control" ] "space" awful.client.floating.toggle
		    { :description "toggle floating" :group "client" })
	 (awful.key [ modkey "Control" ] "Return" (fn [c] (c:swap (awful.client.getmaster)))
		    { :description "move to master" :group "client" })
	 (awful.key [ modkey ] "o" (fn [c] (c:move_to_screen))
		    { :description "move to screen" :group "client" })
	 (awful.key [ modkey ] "t" (fn [c] (set c.ontop (not c.ontop)))
		    { :description "toggle keep on top" :group "client" })))

(for [i 1 9]
  (set globalkeys (gears.table.join globalkeys
        ;; View tag only.
        (awful.key [ modkey ] (.. "#" (+ i 9))
		   (fn []
		       (let [scr (awful.screen.focused)
			     tag (. scr.tags i)]
			 (if tag (tag:view_only))))
                   { :description (.. "view tag #" i) :group "tag"})
        ;; Toggle tag display.
        (awful.key [ modkey "Control" ] (.. "#" (+ i 9))
                   (fn []
		       (let [scr (awful.screen.focused)
			     tag (. scr.tags i)]
			 (if tag (awful.tag.viewtoggle tag))))
                   { :description (.. "toggle tag #" i) :group "tag"})
        ;; Move client to tag.
        (awful.key [ modkey "Shift" ] (.. "#" (+ i 9))
                   (fn []
		     (when client.focus
		       (let [tag (. client.focus.screen.tags i)]
			 (if tag (client.focus:move_to_tag tag)))))
                   { :description (.. "move focused client to tag #" i) :group "tag"})
        ;; Toggle tag on focused client.
        (awful.key [ modkey "Control" "Shift" ] (.. "#" (+ i 9))
                   (fn []
                     (when client.focus
		       (let [tag (client.focus.screen.tags i)]
			 (if tag (client.focus:toggle_tag tag)))))
                   { :description (.. "toggle focused client on tag #" i) :group "tag"}))))
(local clientbuttons
       (gears.table.join
         (awful.button [ ] 1 (fn [c]
             (c:emit_signal "request::activate" "mouse_click" { :raise true })))
         (awful.button [ modkey ] 1 (fn [c]
             (c:emit_signal "request::activate" "mouse_click" { :raise true })
             (awful.mouse.client.move c)))
         (awful.button [ modkey ] 3 (fn [c]
             (c:emit_signal "request::activate" "mouse_click" { :raise true })
             (awful.mouse.client.resize c)))))
;; Set keys
(root.keys globalkeys)
; }}}
