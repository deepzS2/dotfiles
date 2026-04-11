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
      tui = {
        theme = lib.mkForce "kanagawa";
      };
      settings = {
        autoupdate = true;
        permission = let
          gsd-allow = {
            "~/.config/opencode/get-shit-done/*" = "allow";
          };
        in {
          read = gsd-allow;
          external_directory = gsd-allow;
        };
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
