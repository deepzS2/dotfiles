{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.hjem.terminal = {
    pkgs,
    lib,
    ...
  }: {
    config = {
      packages = [pkgs.foot];
      xdg.config.files."foot/foot.ini".source = "${directories.config}/foot.ini";

      systemd.services.foot = {
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        description = "Fast, lightweight and minimalistic Wayland terminal emulator.";
        documentation = ["man:foot(1)"];
        partOf = ["graphical-session.target"];
        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        serviceConfig = {
          Type = "exec";
          ExecStart = "${lib.getExe pkgs.foot} --server";
          Restart = "on-failure";
          OOMPolicy = "continue";
        };
      };
    };
  };
}
