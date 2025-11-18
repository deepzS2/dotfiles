pragma Singleton
import QtQuick

QtObject {
    // Color scheme (Kanagawa)
    readonly property color base00: "#1F1F28" // Background
    readonly property color base01: "#16161D"
    readonly property color base02: "#223249"
    readonly property color base03: "#54546D"
    readonly property color base04: "#727169"
    readonly property color base05: "#DCD7BA" // Foreground
    readonly property color base06: "#C8C093"
    readonly property color base07: "#717C7C"
    readonly property color base08: "#C34043" // Red
    readonly property color base09: "#FFA066" // Orange
    readonly property color base0A: "#C0A36E" // Yellow
    readonly property color base0B: "#76946A" // Green
    readonly property color base0C: "#6A9589" // Cyan
    readonly property color base0D: "#7E9CD8" // Blue
    readonly property color base0E: "#957FB8" // Purple
    readonly property color base0F: "#D27E99" // Pink

    // Font settings
    readonly property font systemFont: ({
            family: "JetBrainsMono Nerd Font",
            pixelSize: 14,
            bold: true
        })
    // Layout constants
    readonly property int barHeight: 45
    readonly property real capsuleHeight: Math.round(barHeight * 0.82)
    readonly property int widgetHeight: 32
    readonly property int widgetRadius: 8
    readonly property int widgetSpacing: 4
    readonly property int widgetPadding: 12
    readonly property int marginSize: 8
    // Update intervals (milliseconds)
    readonly property int clockInterval: 1000
    readonly property int systemInterval: 30000
    readonly property int networkInterval: 5000
    readonly property int batteryInterval: 1000
    // Widget styling
    readonly property color widgetBackground: base00
    readonly property color widgetForeground: base05
    readonly property color widgetBorder: base02
    readonly property real widgetOpacity: 0.95
    readonly property int widgetBorderWidth: 1
    readonly property int widgetShadowOffset: 1
    readonly property real widgetShadowOpacity: 0.185
    // Special colors
    readonly property color urgentColor: base08
    readonly property color warningColor: base09
    readonly property color successColor: base0B
    readonly property color infoColor: base0D
}
