{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.ai = {
    pkgs,
    config,
    ...
  }: {
    programs.nushell.extraEnv = ''
      $env.GOOGLE_API_KEY = (bash -c "cat ${config.age.secrets.gemini_key.path}")
    '';

    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        theme = lib.mkForce "kanagawa";
        autoupdate = true;
        mcp.nixos = {
          enabled = true;
          type = "local";
          command = ["nix" "run" "github:utensils/mcp-nixos"];
        };
      };
    };

    home.packages = [pkgs.gemini-cli];
  };
}
