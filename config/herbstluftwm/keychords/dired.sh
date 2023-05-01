hc() {
    herbstclient "$@"
}

appMod=Mod1
diredKeys=( h d D p )

# Build the command to unbind the keys
diredKeysUnbind=(  )
for k in "${diredKeys[@]}" Escape ; do
    diredKeysUnbind+=( , keyunbind "$k" )
done
hc keybind $appMod-f chain \
    '->' keybind "${diredKeys[0]}" chain "${diredKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-dired \"home\")" \
    '->' keybind "${diredKeys[1]}" chain "${diredKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-dired \"dotfiles\")" \
    '->' keybind "${diredKeys[2]}" chain "${diredKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-dired \"downloads\")" \
    '->' keybind "${diredKeys[3]}" chain "${diredKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-dired \"projects\")" \
    '->' keybind Escape             chain "${diredKeysUnbind[@]}"
