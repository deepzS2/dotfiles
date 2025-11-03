{
  flake.modules.homeManager.javascript = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.development.javascript = {
      enableNodejs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Node.js runtime";
      };
      enableDeno = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Deno runtime";
      };
      enableBun = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Bun runtime";
      };
      enablePnpm = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable pnpm package manager";
      };
    };

    config = let
      cfg = config.development.javascript;
    in {
      home.packages =
        lib.optionals cfg.enableNodejs [pkgs.nodejs]
        ++ lib.optionals cfg.enablePnpm [pkgs.pnpm]
        ++ lib.optionals cfg.enableDeno [pkgs.deno]
        ++ lib.optionals cfg.enableBun [pkgs.bun];
    };
  };
}
