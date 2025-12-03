pragma Singleton
import QtQuick
import "."

QtObject {
    // ==========================================================================
    // Material You Colors - Import from generated Colors.qml
    // Run `matugen image <wallpaper>` to regenerate colors
    // ==========================================================================
    readonly property QtObject colors: Colors

    // ==========================================================================
    // Semantic color aliases (for easier migration from Base16)
    // ==========================================================================
    // These map Material You colors to Base16-like semantics
    readonly property color base00: colors.background      // Background
    readonly property color base01: colors.surfaceContainerLow
    readonly property color base02: colors.surfaceContainer
    readonly property color base03: colors.outlineVariant
    readonly property color base04: colors.outline
    readonly property color base05: colors.conSurface       // Foreground
    readonly property color base06: colors.conSurfaceVariant
    readonly property color base07: colors.surfaceContainerHigh
    readonly property color base08: colors.error           // Red/Error
    readonly property color base09: colors.tertiary        // Orange/Accent
    readonly property color base0A: colors.secondary       // Yellow/Warning
    readonly property color base0B: colors.primary         // Green/Success (using primary)
    readonly property color base0C: colors.secondaryContainer // Cyan
    readonly property color base0D: colors.primary         // Blue/Info
    readonly property color base0E: colors.tertiary        // Purple
    readonly property color base0F: colors.tertiaryContainer // Pink/Brown

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
    readonly property color widgetBackground: colors.surface
    readonly property color widgetForeground: colors.conSurface
    readonly property color widgetBorder: colors.outlineVariant
    readonly property real widgetOpacity: 0.95
    readonly property int widgetBorderWidth: 1
    readonly property int widgetShadowOffset: 1
    readonly property real widgetShadowOpacity: 0.185
    // Special colors
    readonly property color urgentColor: colors.error
    readonly property color warningColor: colors.tertiary
    readonly property color successColor: colors.primary
    readonly property color infoColor: colors.secondary
}
