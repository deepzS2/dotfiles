{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.editor.vscode;
in {
  options = {
    editor.vscode.enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # VSCode
      pkgs.vscode

      # Nix IDE
      pkgs.nixd
      pkgs.alejandra
    ];
  };
}
