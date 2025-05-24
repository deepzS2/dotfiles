{
  lib,
  config,
  ...
}: let
  cfg = config.shell.prompt;
  nushell-cfg = config.shell.nushell;
in {
  options = {
    shell.prompt.enable = lib.mkEnableOption "Starship prompt";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableNushellIntegration = nushell-cfg.enable;
      settings = {
        add_newline = true;

        format = lib.concatStrings [
          "$directory"
          "$git_branch"
          "$git_status"
          "$fill"
          "$lua"
          "$python"
          "$nodejs"
          "$bun"
          "$aws"
          "$docker_context"
          "$jobs"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];

        palette = "rose-pine-moon";
        palettes = {
          "rose-pine-moon" = {
            base = "#232136";
            surface = "#2a273f";
            overlay = "#393552";
            muted = "#6e6a86";
            subtle = "#908caa";
            text = "#e0def4";
            love = "#eb6f92";
            gold = "#f6c177";
            rose = "#ea9a97";
            pine = "#3e8fb0";
            foam = "#9ccfd8";
            iris = "#c4a7e7";
            highlight_low = "#2a283e";
            highlight_med = "#44415a";
            highlight_high = "#56526e";
          };
        };

        # module-specific tables
        fill = {
          symbol = " ";
        };

        character = {
          success_symbol = "[➜](bold foam)";
          error_symbol = "[✗](bold love)";
          vicmd_symbol = "[V](bold foam)";
        };

        aws = {
          format = "on [$symbol(\\($region\\) )]($style)";
          style = "blue";
          region_aliases = {
            "sa-east-1" = "sa";
            "us-east-1" = "us";
          };
        };

        directory = {
          format = "[$path ]($style)";
          truncation_length = 4;
          truncation_symbol = "…/";
          truncate_to_repo = false;
        };

        gcloud = {
          format = "on [$symbol(\\($region\\))]($style)";
        };

        git_branch = {
          style = "fg:foam";
          symbol = " ";
          format = "on [$symbol$branch ]($style)";
        };

        git_status = {
          style = "fg:love";
          format = "([$all_status$ahead_behind]($style) )";
        };

        memory_usage = {
          disabled = false;
          threshold = 50;
        };
      };
    };
  };
}
