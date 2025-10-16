# Elixir development configuration module for Home Manager
# Exported as flake.modules.homeManager.elixir
{
  flake.modules.homeManager.elixir = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption mkIf mkOption types literalExpression;
    cfg = config.development.elixir;
  in {
    options.development.elixir = {
      enable = mkEnableOption "Elixir programming language";

      package = mkOption {
        type = types.package;
        default = pkgs.elixir;
        description = "The Elixir package to use.";
      };

      erlangPackage = mkOption {
        type = types.package;
        default = pkgs.erlang;
        description = "The Erlang/OTP package to use.";
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = "Extra Elixir related packages to install.";
        example = literalExpression "[ pkgs.rebar3 ]";
      };
    };

    config = mkIf cfg.enable {
      home.packages =
        [
          cfg.package
          cfg.erlangPackage
        ]
        ++ cfg.extraPackages;
    };
  };
}
