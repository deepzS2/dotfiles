{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  inherit (inputs.llm-agents.packages.${system}) pi rtk;
in {
  packages = [pi rtk];
}
