let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoiE+DqG3s3aDpjYZsiLcoU+SDgnRaKP0Q3DWRvQB2B mg433@harry-potter";
in {
  "wireguard.age".publicKeys = [key];
}
