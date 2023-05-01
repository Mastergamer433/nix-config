hc() {
    herbstclient "$@"
}

appMod=Mod1
webKeys=( g y r e )

# Build the command to unbind the keys
webKeysUnbind=(  )
for k in "${webKeys[@]}" Escape ; do
    webKeysUnbind+=( , keyunbind "$k" )
done
hc keybind $appMod-w chain \
    '->' keybind "${webKeys[0]}" chain "${webKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-search-google)" \
    '->' keybind "${webKeys[1]}" chain "${webKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-search-youtube)" \
    '->' keybind "${webKeys[2]}" chain "${webKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-github-repo t)" \
    '->' keybind "${webKeys[3]}" chain "${webKeysUnbind[@]}" , spawn emacsclient -e "(keo/wm-open-github-repo)" \
    '->' keybind Escape             chain "${webKeysUnbind[@]}"
