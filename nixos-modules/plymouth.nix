# Nice defaults for plymouth themes
{
  boot = {
    plymouth.enable = true;
    consoleLogLevel = 3;
    kernelParams = ["quiet" "rd.udev.log_level=3" "rd.systemd.show_status=auto"];
    loader.timeout = 0;
  };
}
