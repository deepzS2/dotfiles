{inputs, ...}: {
  flake.modules.hjem.ai = {
    pkgs,
    lib,
    ...
  }: let
    ollamaPackage = pkgs.ollama;
  in {
    config = {
      packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi ollamaPackage];

      systemd.services.ollama = {
        description = "Server for local large language models";
        after = ["network.target"];
        wantedBy = ["default.target"];

        serviceConfig = {
          ExecStart = "${lib.getExe ollamaPackage} serve";
          Environment = ["OLLAMA_HOST=127.0.0.1:11434"];
        };
      };
    };
  };
}
