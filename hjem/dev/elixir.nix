{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.development.elixir;
in {
  options.development.elixir = {
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra Elixir-related packages to install";
      example = lib.literalExpression "[ pkgs.elixir-ls ]";
    };
  };

  config.packages =
    builtins.attrValues {inherit (pkgs.beamPackages) elixir erlang;}
    ++ cfg.extraPackages;
}
