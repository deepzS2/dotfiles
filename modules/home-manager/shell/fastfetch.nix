{self, ...}: {
  flake.modules.homeManager.fastfetch = {
    pkgs,
    config,
    ...
  }: let
    inherit (config.lib.stylix.colors) withHashtag;
  in {
    home.packages = [
      pkgs.gowall
      pkgs.kitty
    ];

    home.file.".config/gowall/config.yml".text = ''
      InlineImagePreview: true
      OutputFolder: "Imagens/gowall"

      themes:
        - name: "kanagawa"
          colors:
            - "${withHashtag.base00}"
            - "${withHashtag.base01}"
            - "${withHashtag.base02}"
            - "${withHashtag.base03}"
            - "${withHashtag.base04}"
            - "${withHashtag.base05}"
            - "${withHashtag.base06}"
            - "${withHashtag.base07}"
            - "${withHashtag.base08}"
            - "${withHashtag.base09}"
            - "${withHashtag.base0A}"
            - "${withHashtag.base0B}"
            - "${withHashtag.base0C}"
            - "${withHashtag.base0D}"
            - "${withHashtag.base0E}"
            - "${withHashtag.base0F}"
    '';

    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = {
          type = "kitty-icat";
          source = "${self}/config/fastfetch/nix-logo.png";
          width = 22;
          height = 22;
        };
        display.separator = " ";
        modules = [
          "break"
          {
            key = "󰅐 ";
            keyColor = "37";
            type = "uptime";
          }
          {
            key = " ";
            keyColor = "31";
            type = "packages";
          }
          {
            key = " ";
            keyColor = "32";
            type = "wm";
          }
          {
            key = " ";
            keyColor = "33";
            type = "shell";
          }
          {
            key = " ";
            keyColor = "34";
            type = "terminal";
          }
          {
            key = " ";
            keyColor = "35";
            type = "disk";
          }
          {
            key = "󰑭 ";
            keyColor = "36";
            type = "memory";
          }
          "break"
          {
            type = "custom";
            format = "{#90}  {#31}  {#32}  {#33}  {#34}  {#35}  {#36}  {#37} ";
          }
          "break"
        ];
      };
    };
  };
}
