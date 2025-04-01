inputs: {config, lib, ...}: let
  system-partition = "/persistent/system";
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko

    inputs.self.diskoConfigurations.multi-user-workstation
  ];

  disko.devices.disk.nixos.content.partitions.system.content.content.subvolumes."/persistent" = {
    mountpoint = system-partition;
    mountOptions = [
      "compress=zstd"
      "noatime"
    ];
  };

  enviroment.persistence.${system-partition} = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/systemd/"
      "/etc/credstore/"
      "/etc/credstore.encrypted/"
      "/etc/nixos"
      { directory = "/root"; user = "root"; group = "root"; mode = "0700"; }
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  boot.initrd.postResumeCommnads = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-partlabel/${
      config.disko.devices.disk.nixos.content.partitions.system.label
    } /btrfs_tmp

    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Since we don't want to introduce any data loss, the user is responsible for cleaning up old_roots.
    # Through this process they will discover new persistence locations and be able to generate auto-cleanup scripts.
    # It is unclear if the system would still boot if the persistent partition is full.

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
    rmdir /btrfs_tmp
  '';

  fileSystems."/root".neededForBoot = true;
}
