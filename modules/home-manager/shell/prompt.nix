# Starship prompt configuration module for Home Manager
# Exported as flake.modules.homeManager.prompt
{
  flake.modules.homeManager.prompt = {
    lib,
    ...
  }: {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
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

        # module-specific tables
        fill = {
          symbol = " ";
        };

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold base08)";
          vicmd_symbol = "[V](bold base04)";
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
          symbol = " ";
          format = "on [$symbol$branch ]($style)";
        };

        git_status = {
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
