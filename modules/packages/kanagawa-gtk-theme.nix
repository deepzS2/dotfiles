{inputs, ...}: {
  perSystem = {
    lib,
    system,
    ...
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
  in {
    packages.kanagawa-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
      pname = "kanagawa-gtk-theme";
      version = "unstable-2025-10-23";

      src = pkgs.fetchFromGitHub {
        owner = "Fausto-Korpsvart";
        repo = "Kanagawa-GKT-Theme";
        rev = "main";
        sha256 = "sha256-UdMoMx2DoovcxSp/zBZ3PRv/Qpj+prd0uPm1gmdak2E=";
      };

      nativeBuildInputs = with pkgs; [
        sassc
        which
      ];

      buildInputs = with pkgs; [
        gtk-engine-murrine
        gnome-themes-extra
      ];

      postPatch = ''
        patchShebangs themes/install.sh
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/themes

        ./themes/install.sh \
          -n "Kanagawa" -l \
          --tweaks macos outline \
          -c dark \
          -d $out/share/themes

        runHook postInstall
      '';

      meta = with lib; {
        description = "Kanagawa GTK Theme with Wave colors and macOS buttons";
        homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
      };
    };
  };
}
