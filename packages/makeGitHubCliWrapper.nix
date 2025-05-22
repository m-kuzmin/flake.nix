{
  stdenv,
  lib,
  makeBinaryWrapper,
  gh,
}: {
  name, # Derivation name
  config ? {
    # gh config.yaml
    version = 1;
    aliases.clone = "repo clone";
  },
  username, # GitHub username
}:
stdenv.mkDerivation {
  pname = "gh-${name}";
  inherit (gh) version;
  nativeBuildInputs = [makeBinaryWrapper];
  buildInputs = [gh];

  dontUnpack = true;
  dontPatch = true;
  dontBuild = true;

  installPhase = let
    ghconfig = stdenv.mkDerivation {
      pname = "gh-${name}";
      inherit (gh) version;
      nativeBuildInputs = [makeBinaryWrapper];
      buildInputs = [gh];

      dontUnpack = true;
      dontPatch = true;
      dontBuild = true;

      config = lib.generators.toYAML {} config;
      hosts = ''
        github.com:
          git_protocol: ssh
          users:
            ${username}:
          user: ${username}
      '';
      installPhase = ''
        mkdir -p "$out/gh"

        echo -n "$config" > "$out/gh/config.yml"
        echo -n "$hosts" > "$out/gh/hosts.yml"
      '';
      dontFixup = true;
    };
  in ''
    runHook preInstall

    makeWrapper "${lib.getExe gh}" "$out/bin/gh" \
      --set XDG_CONFIG_HOME "${ghconfig}"

    runHook postInstall
  '';

  dontFixup = true;
}
