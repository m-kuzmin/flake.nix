inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  pkgs-bluetooth = inputs.nixpkgs-bluetooth.legacyPackages.${config.nixpkgs.system};
in {
  # Temporary package downgrade to fix https://github.com/bluez/bluez/issues/2562
  services.pipewire.package = lib.mkForce pkgs-bluetooth.pipewire;
  services.pipewire.wireplumber.package = lib.mkForce pkgs-bluetooth.wireplumber;
  boot.kernelPackages = lib.mkForce pkgs-bluetooth.linuxPackages;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = [pkgs.pavucontrol];

  services.libinput.enable = true;
  services.fprintd.enable = true;
}
