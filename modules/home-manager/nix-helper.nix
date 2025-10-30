# Nix helper (nh) configuration module for Home Manager
# Exported as flake.modules.homeManager.nix-helper
{
  flake.modules.homeManager.nix-helper = {config, ...}: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
