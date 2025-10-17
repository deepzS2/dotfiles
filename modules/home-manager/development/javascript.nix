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
      home.packages = with pkgs;
        lib.optionals cfg.enableNodejs [nodejs]
        ++ lib.optionals cfg.enablePnpm [pnpm]
        ++ lib.optionals cfg.enableDeno [deno]
        ++ lib.optionals cfg.enableBun [bun];
    };
  };
}
