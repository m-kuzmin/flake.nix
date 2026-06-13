/*
Automatically check if the git repository is clean, update the flake lock and commit the changes.
*/
{writeShellScriptBin}:
writeShellScriptBin "flake-update" ''
  fatal() {
      local text="$*"
      local error_color="\e[1;37;41m"
      local reset_color="\e[0m"

      printf "%b  Error  %b %s\n" "''${reset_color}''${error_color}" "''${reset_color}" "''${text}"
      exit 1
  }

  ok() {
      local text="$*"
      local ok_color="\e[1;37;42m"
      local reset_color="\e[0m"

      printf "%b  OK     %b %s\n" "''${reset_color}''${ok_color}" "''${reset_color}" "''${text}"
  }

  info_() {
      local text="$*"
      local info_color="\e[1;37;44m"
      local reset_color="\e[0m"

      printf "%b  Info   %b %s\n" "''${reset_color}''${info_color}" "''${reset_color}" "''${text}"
  }

  warn() {
      local text="$*"
      local warn_color="\e[1;37;43m"
      local reset_color="\e[0m"

      printf "%b  Warn   %b %s\n" "''${reset_color}''${warn_color}" "''${reset_color}" "''${text}"
  }

  info_ 'Checking if the working tree is clean'
  if test -n "$(git status --porcelain)"; then
      git status;
      fatal 'Working directory is not clean';
  fi

  info_ 'Updating the flake inputs';
  nix flake update ||
  fatal 'Failed to update the flake';

  if test -z "$(git status --porcelain)"; then
      warn 'Nothing to update'
      exit 0
  fi

  info_ 'Commiting the flake.lock file';
  git add flake.lock &&
  git commit -m 'nix flake update' ||
  fatal 'Failed to commit the updated flake';

  ok 'Updated the flake and commited the changes';
''
