{
  flake.modules.homeManager.javascript = {pkgs, ...}: {
    home.packages = with pkgs; [
      nodejs
      pnpm
      deno
      bun
    ];
  };
}
