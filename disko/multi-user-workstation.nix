let
  /*
  Set this in hardware-configuration.nix:
  disko.devices.disk.nixos.device = "/dev/disk/by-id/ ... ";
  disko.devices.disk.nixos.content.partitions.system.size = "...G";
  disko.devices.disk.nixos.content.partitions.swap.size = "...G";

  Use a separate partition for /home/${user} as the system partition should be unlockable unattended w/TPM.
  disko.devices.disk.nixos.content.partitions.user-${user} = { ... };

  User's home directory encryption should be bound to their user password.
  This setup retains reasonable confidentiality of the entire system, while removing the need for extra
  passwords that are not used as often and are thus prone to being forgotten.

  There is a risk of the user password being compromised because it is also stored in /etc/shadow.
  However, this setup provides significant convinience over the slight security compromise.
  */
in {
  disko.devices.disk.nixos = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";

      partitions = {
        efiboot = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };

        # Nix store & impermanence old roots
        system = {
          size = "100G";
          priority = "200";
          content = {
            type = "luks";
            name = "nixos-system";
            settings = {
              allowDiscards = true;
            };
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/nix-store" = {
                  mountpoint = "/nix/store";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # When using impermance, use this as the "tmpfs" subvolume.
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };

        swap = {
          size = "20G";
          type = "8200";
          priority = "300";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };

        home = {
          type = "8302";
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
          };
        };

        rescue = {
          type = "8301";
          start = "-10G";
          end = "-0";
        };
      };
    };
  };
}
