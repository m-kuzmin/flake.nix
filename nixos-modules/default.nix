inputs: {
  cosmic-de = import ./cosmic-de.nix;
  impermanent-workstation = import ./impermanent-workstation.nix inputs;
  github = import ./github.nix;
  enable-flakes = {nix.settings.experimental-features = ["nix-command" "flakes"];};
  homed-users = import ./homed-users.nix;
  syncthing = import ./syncthing.nix;
  borg-user = import ./borg-user.nix;
}
