{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  libglvnd,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
}: let
  runtimeLibs = [
    gtk3
    libglvnd
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
  ];
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "misterdownloadmanager";
    version = "0.5.2";

    src = fetchurl {
      url = "https://github.com/anefzaoui/misterdownloadmanager/releases/download/v${finalAttrs.version}/MisterDownloadManager-${finalAttrs.version}-linux-x86_64.deb";
      hash = "sha256-nTMNloSggZzqmHyudgGxxQePx3Uglepuay8v7wNakuE=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [stdenv.cc.cc.lib] ++ runtimeLibs;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p unpacked "$out/bin" "$out/share"

      dpkg-deb -x "$src" unpacked

      install -m755 unpacked/usr/bin/misterdownloadmanager* "$out/bin/"
      cp -r unpacked/usr/share/. "$out/share/"

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram "$out/bin/misterdownloadmanager" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
    '';

    meta = {
      description = "Free, multi-connection download manager";
      homepage = "https://github.com/anefzaoui/misterdownloadmanager";
      license = lib.licenses.gpl3Plus;
      platforms = ["x86_64-linux"];
      mainProgram = "misterdownloadmanager";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  })
