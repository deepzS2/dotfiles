pragma Singleton
import QtQuick
import Quickshell
import "."

Singleton {
    // ==========================================================================
    // Semantic color aliases (for easier migration from Base16)
    // ==========================================================================
    // These map Material You colors to Base16-like semantics
    readonly property color base00: Colors.background      // Background
    readonly property color base01: Colors.surfaceContainerLow
    readonly property color base02: Colors.surfaceContainer
    readonly property color base03: Colors.outlineVariant
    readonly property color base04: Colors.outline
    readonly property color base05: Colors.conSurface       // Foreground
    readonly property color base06: Colors.conSurfaceVariant
    readonly property color base07: Colors.surfaceContainerHigh
    readonly property color base08: Colors.error           // Red/Error
    readonly property color base09: Colors.tertiary        // Orange/Accent
    readonly property color base0A: Colors.secondary       // Yellow/Warning
    readonly property color base0B: Colors.primary         // Green/Success (using primary)
    readonly property color base0C: Colors.secondaryContainer // Cyan
    readonly property color base0D: Colors.primary         // Blue/Info
    readonly property color base0E: Colors.tertiary        // Purple
    readonly property color base0F: Colors.tertiaryContainer // Pink/Brown

    // Font settings
    readonly property font systemFont: ({
            family: "JetBrainsMono Nerd Font",
            pixelSize: 14,
            bold: true
        })
    readonly property font systemFontBig: ({
            family: "JetBrainsMono Nerd Font",
            pixelSize: 19,
            bold: true
        })
    // Layout constants
    readonly property int barHeight: 50
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
    readonly property color widgetBackground: Colors.surface
    readonly property color widgetForeground: Colors.conSurface
    readonly property color widgetBorder: Colors.outlineVariant
    readonly property real widgetOpacity: 0.95
    readonly property int widgetBorderWidth: 1
    readonly property int widgetShadowOffset: 1
    readonly property real widgetShadowOpacity: 0.185
    // Special colors
    readonly property color urgentColor: Colors.error
    readonly property color warningColor: Colors.tertiary
    readonly property color successColor: Colors.primary
    readonly property color infoColor: Colors.secondary
}
