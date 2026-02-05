{
  flake.modules.homeManager.rust = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.development.rust = {
      enableBacon = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable bacon (background rust code checker)";
      };
      enableCargoEdit = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable cargo-edit (cargo add, rm, upgrade commands)";
      };
      enableCargoExpand = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable cargo-expand (macro expansion tool)";
      };
      enableCargoUdeps = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable cargo-udeps (find unused dependencies)";
      };
      enableCargoWatch = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable cargo-watch (watch for changes and run commands)";
      };
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Extra Rust-related packages to install";
        example = lib.literalExpression "[ pkgs.cargo-flamegraph pkgs.cargo-audit ]";
      };
    };

    config = let
      cfg = config.development.rust;
    in {
      home.packages =
        [pkgs.rustc pkgs.cargo]
        ++ lib.optionals cfg.enableBacon [pkgs.bacon]
        ++ lib.optionals cfg.enableCargoEdit [pkgs.cargo-edit]
        ++ lib.optionals cfg.enableCargoExpand [pkgs.cargo-expand]
        ++ lib.optionals cfg.enableCargoUdeps [pkgs.cargo-udeps]
        ++ lib.optionals cfg.enableCargoWatch [pkgs.cargo-watch]
        ++ cfg.extraPackages;
    };
  };
}
