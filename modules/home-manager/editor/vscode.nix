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
        extensions = [
          pkgs.vscode-extensions.jnoortheen.nix-ide
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
              options = let
                flake-path = "${config.home.homeDirectory}/.dotfiles";
              in {
                nixos.expr = "(builtins.getFlake \"${flake-path}\").nixosConfigurations.deepz.options";
                home-manager.expr = "(builtins.getFlake \"${flake-path}\").nixosConfigurations.deepz.options.home-manager.users.type.getSubOptions []";
                flake-parts.expr = "(builtins.getFlake \"${flake-path}\").debug.options";
              };
            };
          };
        };
      };
    };
  };
}
