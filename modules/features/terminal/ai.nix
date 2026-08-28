{inputs, ...}: {
  flake.modules.hjem.ai = {pkgs, ...}: let
    llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    config = {
      packages = [llm-agents.pi llm-agents.rtk];
    };
  };
}
