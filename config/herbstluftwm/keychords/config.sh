hc() {
    herbstclient "$@"
}

appMod=Mod1
configKeys=( e h )

# Build the command to unbind the keys
configKeysUnbind=(  )
for k in "${configKeys[@]}" Escape ; do
    configKeysUnbind+=( , keyunbind "$k" )
done
hc keybind $appMod-c chain \
    '->' keybind "${configKeys[0]}" chain "${configKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-config \"emacs\")" \
    '->' keybind "${configKeys[1]}" chain "${configKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-config \"herbstluft\")" \
    '->' keybind Escape             chain "${configKeysUnbind[@]}"
