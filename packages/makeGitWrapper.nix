{
  stdenv,
  lib,
  makeBinaryWrapper,
  writeText,
  git,
}: {
  name,
  config,
}:
stdenv.mkDerivation {
  pname = "git-${name}";
  inherit (git) version;
  nativeBuildInputs = [makeBinaryWrapper];
  buildInputs = [git];

  dontUnpack = true;
  dontPatch = true;
  dontBuild = true;

  installPhase = let
    gitconfig = writeText "git-${name}-config" (lib.concatMapStringsSep "\n" lib.generators.toGitINI config);
  in ''
    runHook preInstall

    makeWrapper "${lib.getExe git}" "$out/bin/git" \
      --set GIT_CONFIG_GLOBAL "${gitconfig}"

    runHook postInstall
  '';

  dontFixup = true;
}
