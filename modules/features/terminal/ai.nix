{lib, ...}: {
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
      tui = {
        theme = lib.mkForce "kanagawa";
      };
      settings = {
        plugin = ["superpowers@git+https://github.com/obra/superpowers.git"];
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
