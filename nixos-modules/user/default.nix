# User-level packages.
#
# Import them in `users.users.<name>.imports`.
{
  desktop = import ./desktop.nix;
  programming = import ./programming.nix;
}
