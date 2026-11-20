{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  sassc,
  which,
  gnome-themes-extra,
}:
stdenvNoCC.mkDerivation {
  pname = "kanagawa-gtk-theme";
  version = "unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "main";
    sha256 = "sha256-UdMoMx2DoovcxSp/zBZ3PRv/Qpj+prd0uPm1gmdak2E=";
  };

  nativeBuildInputs = [sassc which];
  buildInputs = [gnome-themes-extra];

  postPatch = ''
    patchShebangs themes/install.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes

    ./themes/install.sh \
      -n "Kanagawa" \
      --tweaks macos outline \
      -c dark \
      -d $out/share/themes

    runHook postInstall
  '';

  meta = {
    description = "Kanagawa GTK Theme with Wave colors and macOS buttons";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
