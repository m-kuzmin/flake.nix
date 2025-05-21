{
  pkgs,
  lib,
  ...
}: let
  backupService = {schedule}:
    pkgs.writeShellApplication {
      name = "borg-backup-home-${schedule}";
      runtimeInputs = [pkgs.borgbackup];
      text = ''
        config="''${XDG_CONFIG_HOME:-$HOME/.config}/borg-scheduled-backup"
        repo="$(head -1 "''${config}/repo.home")"

        if [ ! -e "$config" ] && [ -r "$config" ]; then
          echo "$config must exist and be readable"
          exit 1
        fi

        if [ -z "$repo" ]; then
          echo "''${config}/repo.home must contain the borg repository path"
          exit 1
        fi

        cd "$HOME"

        systemd-inhibit \
          --what "shutdown:sleep" \
          --mode "block" \
          --who "borg" \
          --why "Scheduled (${schedule}) backup of $HOME is in progress" \
          borg create --patterns-from "''${config}/patterns.home" "''${repo}::home-{hostname}-{user}-${schedule}-{utcnow}"
      '';
    };

  schedule = "1w";
  startAt = "Sun *-*-* 04:00:00";
in {
  systemd.user.timers."borg-backup-${schedule}" = {
    description = "1 week timer for %h borg backup";
    timerConfig.Persistent = true;
  };

  systemd.user.services."borg-backup-${schedule}" = {
    description = "Borg backup %h every ${schedule}";
    inherit startAt;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe (backupService {inherit schedule;});

      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
    };
  };
}
