# Go development configuration module for Home Manager
# Exported as flake.modules.homeManager.go
{
  flake.modules.homeManager.go = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption mkOption types literalExpression mkIf lists;
    cfg = config.development.go;
  in {
    options.development.go = {
      enable = mkEnableOption "Go programming language";

      package = mkOption {
        type = types.package;
        default = pkgs.go;
        description = "The Go package to use.";
      };

      air = {
        enable = mkEnableOption "air for live reloading";
        package = mkOption {
          type = types.package;
          default = pkgs.air;
          description = "The air package to use.";
        };
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Extra Go related packages to install.";
        example = literalExpression "[ pkgs.delve ]";
      };
    };

    config = mkIf cfg.enable {
      home.packages =
        [cfg.package]
        ++ lists.optionals (cfg.air.enable) [cfg.air.package]
        ++ cfg.extraPackages;
    };
  };
}
