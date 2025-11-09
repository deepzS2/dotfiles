{
  flake.modules.nixos.notifications = {pkgs, ...}: {
    environment.systemPackages = [pkgs.libnotify];
  };
}
