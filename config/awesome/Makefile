all: rc.lua keybinds.lua

%.lua: %.fnl
	fennel --compile $< > $@
