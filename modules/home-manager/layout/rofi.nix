{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.rofi;
in {
  options = {
    layout.rofi.enable = lib.mkEnableOption "Rofi (Wayland support)";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "ghostty";
      package = pkgs.rofi;
      extraConfig = {
        # Author : Aditya Shakya (adi1090x)
        # Github : @adi1090x
        # Configuration For Rofi Version: 1.7.3
        modi = "drun,run,filebrowser,window";
        case-sensitive = false;
        cycle = true;
        filter = "";
        scroll-method = 0;
        normalize-match = true;
        show-icons = true;
        icon-theme = "Papirus";
        steal-focus = false;
        matching = "normal";
        tokenize = true;
        ssh-client = "ssh";
        ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
        parse-hosts = true;
        parse-known-hosts = true;
        drun-categories = "";
        drun-match-fields = "name,generic,exec,categories,keywords";
        drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        drun-show-actions = false;
        drun-url-launcher = "xdg-open";
        drun-use-desktop-cache = false;
        drun-reload-desktop-cache = false;
        drun-parse-user = true;
        drun-parse-system = true;
        run-command = "{cmd}";
        run-list-command = "";
        run-shell-command = "{terminal} -e {cmd}";
        run-fallback-icon = "application-x-addon";
        drun-fallback-icon = "application-x-addon";
        window-match-fields = "title,class,role,name,desktop";
        window-command = "wmctrl -i -R {window}";
        window-format = "{w} - {c} - {t:0}";
        window-thumbnail = false;
        disable-history = false;
        sorting-method = "normal";
        max-history-size = 25;
        display-window = "Windows";
        display-windowcd = "Window CD";
        display-run = "Run";
        display-ssh = "SSH";
        display-drun = "Apps";
        display-combi = "Combi";
        display-keys = "Keys";
        display-filebrowser = "Files";
        terminal = "rofi-sensible-terminal";
        font = "Mono 12";
        sort = false;
        threads = 0;
        click-to-exit = true;
        filebrowser-directories-first = true;
        filebrowser-sorting-method = "name";
        timeout-action = "kb-cancel";
        timeout-delay = 0;
        kb-delete-entry = "Shift+Delete";
      };
    };

    home.file = {
      ".config/rofi/launcher.rasi".source = ../../../config/rofi/launcher.rasi;
      ".config/rofi/powermenu.rasi".source = ../../../config/rofi/powermenu.rasi;
      ".config/rofi/powermenu_confirm.rasi".source = ../../../config/rofi/powermenu_confirm.rasi;
      ".config/rofi/wifimenu.rasi".source = ../../../config/rofi/wifimenu.rasi;
      ".config/rofi/wifimenu_password.rasi".source = ../../../config/rofi/wifimenu_password.rasi;
    };
  };
}
