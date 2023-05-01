hc() {
    herbstclient "$@"
}

myScratchpadCommand=~/.config/herbstluftwm/scratchpads.sh
Mod=Mod4
scratchpadKeys=( t s )

# Build the command to unbind the keys
scratchpadKeysUnbind=(  )
for k in "${scratchpadKeys[@]}" Escape ; do
    scratchpadKeysUnbind+=( , keyunbind "$k" )
done
hc keybind $Mod-m chain \
    '->' keybind "${scratchpadKeys[0]}" chain "${scratchpadKeysUnbind[@]}" , spawn $myScratchpadCommand term-scratchpad \
    '->' keybind "${scratchpadKeys[1]}" chain "${scratchpadKeysUnbind[@]}" , spawn $myScratchpadCommand spotify-scratchpad \
    '->' keybind Escape             chain "${scratchpadKeysUnbind[@]}"
