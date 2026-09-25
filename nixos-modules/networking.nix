# Use systemd-networkd and iwd for WiFi
{lib, ...}: {
  networking.networkmanager.enable = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;
  networking.wireless.iwd.enable = lib.mkDefault true;
  services.resolved.enable = true;
}
