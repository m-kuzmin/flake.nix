{
  # Multi-user workstation. `/` is encrypted w/TMP and `~` with the user's password.
  # Compatible with BTRFS subvolume based impermanence.
  multi-user-workstation = import ./multi-user-workstation.nix;
}
