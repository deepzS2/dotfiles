# JavaScript development configuration module for Home Manager
# Exported as flake.modules.homeManager.javascript
{
  flake.modules.homeManager.javascript = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption lists;
    cfg = config.development.javascript;
  in {
    options.development.javascript = {
      package-managers = {
        enable = lib.mkEnableOption "Whether to enable JavaScript package managers.";
        all = lib.mkEnableOption "Whether to enable all JavaScript package managers." // {default = true;};
        pnpm = lib.mkEnableOption "Whether to enable the PNPM package manager." // {default = cfg.package-managers.all;};
      };

      runtimes = {
        enable = lib.mkEnableOption "Whether to enable JavaScript runtimes.";
        all = lib.mkEnableOption "Whether to enable all JavaScript runtimes." // {default = true;};
        node = lib.mkEnableOption "Whether to enable the Node.js runtime." // {default = cfg.runtimes.all;};
        deno = lib.mkEnableOption "Whether to enable the Deno runtime." // {default = cfg.runtimes.all;};
        bun = lib.mkEnableOption "Whether to enable the Bun runtime." // {default = cfg.runtimes.all;};
      };
    };

    config = {
      home.packages =
        []
        ++ lists.optionals (cfg.package-managers.enable && cfg.package-managers.pnpm) [pkgs.pnpm]
        ++ lists.optionals (cfg.runtimes.enable && cfg.runtimes.node) [pkgs.nodejs]
        ++ lists.optionals (cfg.runtimes.enable && cfg.runtimes.deno) [pkgs.deno]
        ++ lists.optionals (cfg.runtimes.enable && cfg.runtimes.bun) [pkgs.bun];
    };
  };
}
