# WiFi menu script for Home Manager
# Exported as flake.modules.homeManager.script-wifimenu
{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "wifimenu";
          runtimeInputs = [pkgs.networkmanager pkgs.rofi];
          text = ''
            THEME="$HOME/.config/rofi/wifimenu.rasi"
            PASSWORD_THEME="$HOME/.config/rofi/wifimenu-password.rasi"

            send_notification notify "Getting list of available Wi-Fi networks..."

            # Get a list of available wifi connections and morph it into a nice-looking list
            wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

            connected=$(nmcli -fields WIFI g)
            if [[ "$connected" =~ "enabled" ]]; then
            	toggle="󰖪  Disable Wi-Fi"
            elif [[ "$connected" =~ "disabled" ]]; then
            	toggle="󰖩  Enable Wi-Fi"
            fi

            # Use rofi to select wifi network
            chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -theme "$THEME" -p "Wi-Fi SSID: " )
            # Get name of connection
            read -r chosen_id <<< "''${chosen_network: 3}"

            if [ "$chosen_network" = "" ]; then
            	exit
            elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
            	nmcli radio wifi on
            elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
            	nmcli radio wifi off
            else
            	# Message to show when connection is activated successfully
              	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
            	# Get saved connections
            	saved_connections=$(nmcli -g NAME connection)
            	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
            		nmcli connection up id "$chosen_id" | grep "successfully" && send_notification notify "Connection Established" "$success_message"
            	else
            		if [[ "$chosen_network" =~ "" ]]; then
            			wifi_password=$(rofi -dmenu -p "Password: " -theme "$PASSWORD_THEME")
            		fi
            		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && send_notification notify "Connection Established" "$success_message"
                fi
            fi
          '';
        }
      )
    ];
  };
}
