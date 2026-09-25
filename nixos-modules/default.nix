inputs: {
  app-image = import ./app-image.nix;
  borg-user = import ./borg-user.nix;
  cosmic-de = import ./cosmic-de.nix;
  enable-flakes = {nix.settings.experimental-features = ["nix-command" "flakes"];};
  gaming = import ./gaming.nix;
  gc = import ./gc.nix;
  github = import ./github.nix;
  homed-users = import ./homed-users.nix;
  kvm = import ./kvm.nix;
  networking = import ./networking.nix;
  repart = ./repart.nix;
  syncthing = import ./syncthing.nix;
}
