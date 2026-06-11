{
  flake.modules.homeManager.discord = {pkgs, ...}: {
    programs.discord.enable = true;
  };
}
