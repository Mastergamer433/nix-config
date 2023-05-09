hc() {
    herbstclient "$@"
}

Mod=Mod4
sshKeys=( p r R )

# Build the command to unbind the keys
sshKeysUnbind=(  )
for k in "${sshKeys[@]}" Escape ; do
    sshKeysUnbind+=( , keyunbind "$k" )
done
hc keybind $Mod-g chain \
    '->' keybind "${sshKeys[0]}" chain "${sshKeysUnbind[@]}" , spawn alacritty -c "ssh 10.10.10.2"
    '->' keybind "${sshKeys[1]}" chain "${sshKeysUnbind[@]}" , spawn alacritty -c "ssh 10.10.10.3" \
    '->' keybind "${sshKeys[2]}" chain "${sshKeysUnbind[@]}" , spawn alacritty -c "ssh 10.10.10.1" \
    '->' keybind Escape             chain "${sshKeysUnbind[@]}"
