{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    audio.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.libinput.enable = true;
  services.fprintd.enable = true;
}
