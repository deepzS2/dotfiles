{
  flake.modules.homeManager.elixir = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.development.elixir = {
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Extra Elixir-related packages to install";
        example = lib.literalExpression "[ pkgs.elixir-ls ]";
      };
    };

    config = let
      cfg = config.development.elixir;
    in {
      home.packages =
        builtins.attrValues {inherit (pkgs) elixir erlang;}
        ++ cfg.extraPackages;
    };
  };
}
