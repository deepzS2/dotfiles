{
  lib,
  self,
  ...
}: {
  options.flake.directories = let
    inherit (lib.types) str;
    inherit (lib) mkOption;
  in {
    config = mkOption {
      type = str;
      default = "${self}/config";
      readOnly = true;
      description = "Path to config related directory";
    };

    media = mkOption {
      type = str;
      default = "${self}/media";
      readOnly = true;
      description = "Path to media related directory";
    };
  };
}
