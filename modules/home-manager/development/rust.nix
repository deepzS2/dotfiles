{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types literalExpression lists;
  cfg = config.development.rust;
in {
  options.development.rust = {
    enable = mkEnableOption "Rust programming language";

    package = mkOption {
      type = types.package;
      default = pkgs.rustc;
      description = "The Rust package to use.";
    };

    bacon = {
      enable = mkEnableOption "bacon for background rust checking";
      package = mkOption {
        type = types.package;
        default = pkgs.bacon;
        description = "The bacon package to use.";
      };
    };

    cargo-edit = {
      enable = mkEnableOption "cargo-edit for managing dependencies";
      package = mkOption {
        type = types.package;
        default = pkgs.cargo-edit;
        description = "The cargo-edit package to use.";
      };
    };

    cargo-expand = {
      enable = mkEnableOption "cargo-expand for macro expansion";
      package = mkOption {
        type = types.package;
        default = pkgs.cargo-expand;
        description = "The cargo-expand package to use.";
      };
    };

    cargo-udeps = {
      enable = mkEnableOption "cargo-udeps for finding unused dependencies";
      package = mkOption {
        type = types.package;
        default = pkgs.cargo-udeps;
        description = "The cargo-udeps package to use.";
      };
    };

    cargo-watch = {
      enable = mkEnableOption "cargo-watch for live reloading";
      package = mkOption {
        type = types.package;
        default = pkgs.cargo-watch;
        description = "The cargo-watch package to use.";
      };
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra Rust related packages to install.";
      example = literalExpression "[ pkgs.some-rust-tool ]";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [cfg.package pkgs.cargo]
      ++ lists.optionals cfg.bacon.enable [cfg.bacon.package]
      ++ lists.optionals cfg.cargo-edit.enable [cfg.cargo-edit.package]
      ++ lists.optionals cfg.cargo-expand.enable [cfg.cargo-expand.package]
      ++ lists.optionals cfg.cargo-udeps.enable [cfg.cargo-udeps.package]
      ++ lists.optionals cfg.cargo-watch.enable [cfg.cargo-watch.package]
      ++ cfg.extraPackages;
  };
}
