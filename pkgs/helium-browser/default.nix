{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "helium-browser";
  version = "0.13.3.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-RS+Sn42V+HjCw41N1zayMVIqlgH+i2B2IdVJwBPmw00=";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-y0NY7bLOultaKE+icbVRaQFiO2Epu19vw6RqxRKoC2o=";
    };
  };

  system =
    architectures.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}. Supported systems are: ${lib.attrNames architectures}");

  src =
    let
      inherit (system) arch hash;
    in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
      inherit hash;
    };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps

    cp ${./helium.svg} \
      $out/share/icons/hicolor/scalable/apps/helium.svg

    cat > $out/share/applications/helium-browser.desktop <<EOF
    [Desktop Entry]
    Name=Helium Browser
    Comment=Internet without interruptions
    Exec=${pname} %U
    Terminal=false
    Type=Application
    Icon=helium
    Categories=Network;WebBrowser;
    MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
    StartupWMClass=Helium
    EOF
  '';
  meta = with lib; {
    description = "Internet without interruptions.";
    homepage = "https://helium.computer/";
    license = licenses.gpl3Only;
    mainProgram = pname;
    platforms = builtins.attrNames architectures;
  };
}
