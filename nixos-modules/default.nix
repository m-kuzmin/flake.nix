inputs: {
  cosmic-de = import ./cosmic-de.nix inputs;
  impermanent-workstation = import ./impermanent-workstation.nix inputs;
  enable-flakes = {nix.settings.experimental-features = ["nix-command" "flakes"];};
}
