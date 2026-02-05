{
  flake.modules.homeManager.go = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.development.go = {
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Extra Go-related packages to install";
        example = lib.literalExpression "[ pkgs.golangci-lint pkgs.gopls ]";
      };
    };

    config = let
      cfg = config.development.go;
    in {
      home.packages =
        builtins.attrValues {inherit (pkgs) go air;}
        ++ cfg.extraPackages;
    };
  };
}
