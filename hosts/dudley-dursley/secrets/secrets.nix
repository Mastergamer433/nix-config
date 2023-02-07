let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHk/squ/i55i2RmUM3b03Hmog8hOpaSIrayT49g8I5mV mg433@dudley-dursley";
in {
  "wireguard.age".publicKeys = [key];
}
