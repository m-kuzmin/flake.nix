inputs: {
  borg-user = import ./borg-user.nix;
  cosmic-de = import ./cosmic-de.nix;
  enable-flakes = {nix.settings.experimental-features = ["nix-command" "flakes"];};
  gaming = import ./gaming.nix;
  github = import ./github.nix;
  homed-users = import ./homed-users.nix;
  impermanent-workstation = import ./impermanent-workstation.nix inputs;
  repart = ./repart.nix;
  syncthing = import ./syncthing.nix;
  yubikey-login = import ./yubikey-login.nix;
}
