hc() {
    herbstclient "$@"
}

appMod=Mod1
mediaKeys=( p j k h l v )

# Build the command to unbind the keys
mediaKeysUnbind=(  )
for k in "${mediaKeys[@]}" Escape ; do
    mediaKeysUnbind+=( , keyunbind "$k" )
done

hc keybind $appMod-k chain \
    '->' keybind "${mediaKeys[0]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify play-pause \
    '->' keybind "${mediaKeys[1]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify next \
    '->' keybind "${mediaKeys[2]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify previous \
    '->' keybind "${mediaKeys[3]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify volume 0.01+ \
    '->' keybind "${mediaKeys[4]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify volume 0.01- \
    '->' keybind "${mediaKeys[5]}" chain "${mediaKeysUnbind[@]}" , spawn playerctl --player=spotify volume 0.4 \
    '->' keybind Escape            chain "${mediaKeysUnbind[@]}"
