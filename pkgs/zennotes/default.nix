{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  glib,
  gtk3,
  cairo,
  pango,
  nss,
  nspr,
  alsa-lib,
  cups,
  libuuid,
  libnotify,
  atk,
  at-spi2-atk,
}:

let
  pname = "zennotes";
  version = "2.3.0";

  architectures = {
    "x86_64-linux" = {
      arch = "linux-x86_64";
      hash = "sha256-IvFGK7n3KQVGETmt6hQUy+bZNTOCkfuwH8ifl4KTxxw=";
    };
  };

  system =
    architectures.${stdenv.hostPlatform.system} or (throw ''
      Unsupported system: ${stdenv.hostPlatform.system}
      Supported systems: ${lib.concatStringsSep ", " (lib.attrNames architectures)}
    '');

  src = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/v${version}/ZenNotes-${version}-${system.arch}.AppImage";
    inherit (system) hash;
  };

  appImageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    glib
    gtk3
    atk
    at-spi2-atk
    cairo
    pango
    nss
    nspr
    alsa-lib
    cups
    libuuid
    libnotify
  ];

  extraInstallCommands = ''
    #
    # Desktop entry
    #
    mkdir -p $out/share/applications

    cp ${appImageContents}/ZenNotes.desktop \
      $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail "Exec=AppRun" "Exec=${pname}" \
      --replace "Comment=" "Comment=Keyboard-first local Markdown notes"

    #
    # Icon
    #
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp ${appImageContents}/ZenNotes.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png

    #
    # CLI launcher
    #
    # Upstream ships resources/zen which directly launches the
    # Electron binary. That bypasses the FHS environment generated
    # by wrapType2 and causes missing library errors on NixOS.
    #
    # Instead, execute the wrapped zennotes launcher and point it
    # at the bundled cli.js.
    #
    cat > $out/bin/zen <<EOF
    #!${stdenv.shell}

    export ELECTRON_RUN_AS_NODE=1

    exec "$out/bin/${pname}" \
      ${appImageContents}/resources/cli.js \
      "\$@"
    EOF

        chmod +x $out/bin/zen
  '';

  meta = with lib; {
    description = "Keyboard-first local Markdown notes";
    homepage = "https://zennotes.org/";
    license = licenses.mit;
    mainProgram = pname;
    platforms = [
      "x86_64-linux"
    ];
  };
}
