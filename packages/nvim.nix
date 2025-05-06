{
  stdenv,
  wrapNeovim,
  neovim-unwrapped,
  withPython3 ? false,
  withNodeJs ? false,
  withRuby ? false,
}:
wrapNeovim neovim-unwrapped {
  inherit
    withPython3
    withNodeJs
    withRuby
    ;
  viAlias = true;
  vimAlias = true;
}
