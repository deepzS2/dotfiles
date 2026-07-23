{inputs, ...}: {
  flake.modules.hjem.ai = {pkgs, ...}: {
    config = {
      packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi pkgs.openspec];
    };
  };
}
