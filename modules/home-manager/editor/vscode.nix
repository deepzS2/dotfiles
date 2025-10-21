{
  flake.modules.homeManager.vscode = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [
      pkgs.nixd
      pkgs.alejandra
    ];

    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
        ];

        userSettings = {
          "editor.formatOnSave" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "alejandra";
          "nix.serverSettings" = {
            nixd = {
              nixpkgs.expr = "import <nixpkgs> {}";
              formatting.command = ["alejandra"];
              options = {
                nixos.expr = "(builtins.getFlake \"${config.home.homeDirectory}/.dotfiles\").nixosConfigurations.default.options";
                home-manager.options = "(builtins.getFlake \"${config.home.homeDirectory}/.dotfiles\").nixosConfigurations.default.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
        };
      };
    };
  };
}
