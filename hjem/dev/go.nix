{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.development.go;
in {
  options.development.go = {
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra Go-related packages to install";
      example = lib.literalExpression "[ pkgs.golangci-lint pkgs.gopls ]";
    };
  };

  config.packages =
    builtins.attrValues {inherit (pkgs) go air;}
    ++ cfg.extraPackages;
}
