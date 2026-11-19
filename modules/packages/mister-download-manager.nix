{inputs, ...}: {
  perSystem = {
    lib,
    system,
    ...
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
    };

    runtimeLibs = with pkgs; [
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
  in {
    packages.misterdownloadmanager = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "misterdownloadmanager";
      version = "0.5.2";

      src = pkgs.fetchurl {
        url = "https://github.com/anefzaoui/misterdownloadmanager/releases/download/v${finalAttrs.version}/MisterDownloadManager-${finalAttrs.version}-linux-x86_64.deb";
        hash = "sha256-nTMNloSggZzqmHyudgGxxQePx3Uglepuay8v7wNakuE=";
      };

      nativeBuildInputs = with pkgs; [
        dpkg
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs =
        [
          pkgs.stdenv.cc.cc.lib
        ]
        ++ runtimeLibs;

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

      meta = with lib; {
        description = "Free, multi-connection download manager";
        homepage = "https://github.com/anefzaoui/misterdownloadmanager";
        license = licenses.gpl3Plus;
        platforms = ["x86_64-linux"];
        mainProgram = "misterdownloadmanager";
        sourceProvenance = [sourceTypes.binaryNativeCode];
      };
    });
  };
}
