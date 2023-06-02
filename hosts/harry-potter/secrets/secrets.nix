let
  key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIID1bhNzIcUZNgOAISOb57K7tiXzxLPHxG+hGnjQA68h Encrypt Secrets Nix, Agenix.";
in { "wireguard.age".publicKeys = [ key ];
     "spotify.age".publicKeys = [ key ];}
