{
  lib,
  self,
  ...
}: {
  options.flake.assets = let
    inherit (lib.types) str;
    inherit (lib) mkOption;
  in {
    path = mkOption {
      type = str;
      default = "${self}/assets";
      description = "Path to assets directory";
    };

    media = mkOption {
      type = str;
      default = "${self}/assets/media";
      readOnly = true;
      description = "Path to media directory";
    };
  };
}
