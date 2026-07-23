{
  flake.modules.hjem.vscode = {
    pkgs,
    config,
    ...
  }: {
    config = {
      packages = [
        pkgs.nixd
        pkgs.alejandra
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = [pkgs.vscode-extensions.jnoortheen.nix-ide];
        })
      ];

      xdg.config.files."Code/User/settings.json" = {
        generator = (pkgs.formats.json {}).generate "vscode-settings";
        value = let
          flake-path = "${config.directory}/.dotfiles";
        in {
          "editor.formatOnSave" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "alejandra";
          "nix.serverSettings" = {
            nixd = {
              nixpkgs.expr = "import <nixpkgs> {}";
              formatting.command = ["alejandra"];
              options = {
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
