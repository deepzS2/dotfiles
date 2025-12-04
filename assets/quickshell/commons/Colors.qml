pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property int transitionDuration: 300

    FileView {
        id: colorFile
        // For compatibility with other quickshell paths
        path: `${Quickshell.env("HOME")}/.config/quickshell/colors.json`
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: colorData

            // Default colors (fallback if JSON file doesn't exist)
            property string primary: "#9dcbfc"
            property string conPrimary: "#003355"
            property string primaryContainer: "#134a74"
            property string conPrimaryContainer: "#cfe4ff"
            property string inversePrimary: "#32628d"
            property string primaryFixed: "#cfe4ff"
            property string primaryFixedDim: "#9dcbfc"
            property string conPrimaryFixed: "#001d34"
            property string conPrimaryFixedVariant: "#134a74"
            property string secondary: "#bac8da"
            property string conSecondary: "#243240"
            property string secondaryContainer: "#3a4857"
            property string conSecondaryContainer: "#d6e4f7"
            property string secondaryFixed: "#d6e4f7"
            property string secondaryFixedDim: "#bac8da"
            property string conSecondaryFixed: "#0f1d2a"
            property string conSecondaryFixedVariant: "#3a4857"
            property string tertiary: "#d5bee5"
            property string conTertiary: "#3a2a49"
            property string tertiaryContainer: "#514060"
            property string conTertiaryContainer: "#f0dbff"
            property string tertiaryFixed: "#f0dbff"
            property string tertiaryFixedDim: "#d5bee5"
            property string conTertiaryFixed: "#241532"
            property string conTertiaryFixedVariant: "#514060"
            property string error: "#ffb4ab"
            property string conError: "#690005"
            property string errorContainer: "#93000a"
            property string conErrorContainer: "#ffdad6"
            property string surface: "#101418"
            property string surfaceDim: "#101418"
            property string surfaceBright: "#36393e"
            property string surfaceContainerLowest: "#0b0e12"
            property string surfaceContainerLow: "#191c20"
            property string surfaceContainer: "#1d2024"
            property string surfaceContainerHigh: "#272a2f"
            property string surfaceContainerHighest: "#32353a"
            property string conSurface: "#e0e2e8"
            property string conSurfaceVariant: "#c2c7cf"
            property string surfaceVariant: "#42474e"
            property string inverseSurface: "#e0e2e8"
            property string inverseOnSurface: "#2d3135"
            property string background: "#101418"
            property string conBackground: "#e0e2e8"
            property string outline: "#8c9199"
            property string outlineVariant: "#42474e"
            property string shadow: "#000000"
            property string scrim: "#000000"
            property string sourceColor: "#404e5e"
        }
    }

    Item {
        id: colorAnimator
        visible: false

        // Primary colors
        property color primary: colorData.primary
        Behavior on primary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conPrimary: colorData.conPrimary
        Behavior on conPrimary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color primaryContainer: colorData.primaryContainer
        Behavior on primaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conPrimaryContainer: colorData.conPrimaryContainer
        Behavior on conPrimaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color inversePrimary: colorData.inversePrimary
        Behavior on inversePrimary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color primaryFixed: colorData.primaryFixed
        Behavior on primaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color primaryFixedDim: colorData.primaryFixedDim
        Behavior on primaryFixedDim {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conPrimaryFixed: colorData.conPrimaryFixed
        Behavior on conPrimaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conPrimaryFixedVariant: colorData.conPrimaryFixedVariant
        Behavior on conPrimaryFixedVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Secondary colors
        property color secondary: colorData.secondary
        Behavior on secondary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSecondary: colorData.conSecondary
        Behavior on conSecondary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color secondaryContainer: colorData.secondaryContainer
        Behavior on secondaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSecondaryContainer: colorData.conSecondaryContainer
        Behavior on conSecondaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color secondaryFixed: colorData.secondaryFixed
        Behavior on secondaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color secondaryFixedDim: colorData.secondaryFixedDim
        Behavior on secondaryFixedDim {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSecondaryFixed: colorData.conSecondaryFixed
        Behavior on conSecondaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSecondaryFixedVariant: colorData.conSecondaryFixedVariant
        Behavior on conSecondaryFixedVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Tertiary colors
        property color tertiary: colorData.tertiary
        Behavior on tertiary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conTertiary: colorData.conTertiary
        Behavior on conTertiary {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color tertiaryContainer: colorData.tertiaryContainer
        Behavior on tertiaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conTertiaryContainer: colorData.conTertiaryContainer
        Behavior on conTertiaryContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color tertiaryFixed: colorData.tertiaryFixed
        Behavior on tertiaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color tertiaryFixedDim: colorData.tertiaryFixedDim
        Behavior on tertiaryFixedDim {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conTertiaryFixed: colorData.conTertiaryFixed
        Behavior on conTertiaryFixed {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conTertiaryFixedVariant: colorData.conTertiaryFixedVariant
        Behavior on conTertiaryFixedVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Error colors
        property color error: colorData.error
        Behavior on error {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conError: colorData.conError
        Behavior on conError {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color errorContainer: colorData.errorContainer
        Behavior on errorContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conErrorContainer: colorData.conErrorContainer
        Behavior on conErrorContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Surface colors
        property color surface: colorData.surface
        Behavior on surface {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceDim: colorData.surfaceDim
        Behavior on surfaceDim {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceBright: colorData.surfaceBright
        Behavior on surfaceBright {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceContainerLowest: colorData.surfaceContainerLowest
        Behavior on surfaceContainerLowest {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceContainerLow: colorData.surfaceContainerLow
        Behavior on surfaceContainerLow {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceContainer: colorData.surfaceContainer
        Behavior on surfaceContainer {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceContainerHigh: colorData.surfaceContainerHigh
        Behavior on surfaceContainerHigh {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceContainerHighest: colorData.surfaceContainerHighest
        Behavior on surfaceContainerHighest {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSurface: colorData.conSurface
        Behavior on conSurface {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conSurfaceVariant: colorData.conSurfaceVariant
        Behavior on conSurfaceVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color surfaceVariant: colorData.surfaceVariant
        Behavior on surfaceVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color inverseSurface: colorData.inverseSurface
        Behavior on inverseSurface {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color inverseOnSurface: colorData.inverseOnSurface
        Behavior on inverseOnSurface {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Background colors
        property color background: colorData.background
        Behavior on background {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color conBackground: colorData.conBackground
        Behavior on conBackground {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Outline colors
        property color outline: colorData.outline
        Behavior on outline {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color outlineVariant: colorData.outlineVariant
        Behavior on outlineVariant {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        // Other colors
        property color shadow: colorData.shadow
        Behavior on shadow {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color scrim: colorData.scrim
        Behavior on scrim {
            ColorAnimation {
                duration: transitionDuration
            }
        }

        property color sourceColor: colorData.sourceColor
        Behavior on sourceColor {
            ColorAnimation {
                duration: transitionDuration
            }
        }
    }

    // Expose animated colors to consumers
    readonly property color primary: colorAnimator.primary
    readonly property color conPrimary: colorAnimator.conPrimary
    readonly property color primaryContainer: colorAnimator.primaryContainer
    readonly property color conPrimaryContainer: colorAnimator.conPrimaryContainer
    readonly property color inversePrimary: colorAnimator.inversePrimary
    readonly property color primaryFixed: colorAnimator.primaryFixed
    readonly property color primaryFixedDim: colorAnimator.primaryFixedDim
    readonly property color conPrimaryFixed: colorAnimator.conPrimaryFixed
    readonly property color conPrimaryFixedVariant: colorAnimator.conPrimaryFixedVariant
    readonly property color secondary: colorAnimator.secondary
    readonly property color conSecondary: colorAnimator.conSecondary
    readonly property color secondaryContainer: colorAnimator.secondaryContainer
    readonly property color conSecondaryContainer: colorAnimator.conSecondaryContainer
    readonly property color secondaryFixed: colorAnimator.secondaryFixed
    readonly property color secondaryFixedDim: colorAnimator.secondaryFixedDim
    readonly property color conSecondaryFixed: colorAnimator.conSecondaryFixed
    readonly property color conSecondaryFixedVariant: colorAnimator.conSecondaryFixedVariant
    readonly property color tertiary: colorAnimator.tertiary
    readonly property color conTertiary: colorAnimator.conTertiary
    readonly property color tertiaryContainer: colorAnimator.tertiaryContainer
    readonly property color conTertiaryContainer: colorAnimator.conTertiaryContainer
    readonly property color tertiaryFixed: colorAnimator.tertiaryFixed
    readonly property color tertiaryFixedDim: colorAnimator.tertiaryFixedDim
    readonly property color conTertiaryFixed: colorAnimator.conTertiaryFixed
    readonly property color conTertiaryFixedVariant: colorAnimator.conTertiaryFixedVariant
    readonly property color error: colorAnimator.error
    readonly property color conError: colorAnimator.conError
    readonly property color errorContainer: colorAnimator.errorContainer
    readonly property color conErrorContainer: colorAnimator.conErrorContainer
    readonly property color surface: colorAnimator.surface
    readonly property color surfaceDim: colorAnimator.surfaceDim
    readonly property color surfaceBright: colorAnimator.surfaceBright
    readonly property color surfaceContainerLowest: colorAnimator.surfaceContainerLowest
    readonly property color surfaceContainerLow: colorAnimator.surfaceContainerLow
    readonly property color surfaceContainer: colorAnimator.surfaceContainer
    readonly property color surfaceContainerHigh: colorAnimator.surfaceContainerHigh
    readonly property color surfaceContainerHighest: colorAnimator.surfaceContainerHighest
    readonly property color conSurface: colorAnimator.conSurface
    readonly property color conSurfaceVariant: colorAnimator.conSurfaceVariant
    readonly property color surfaceVariant: colorAnimator.surfaceVariant
    readonly property color inverseSurface: colorAnimator.inverseSurface
    readonly property color inverseOnSurface: colorAnimator.inverseOnSurface
    readonly property color background: colorAnimator.background
    readonly property color conBackground: colorAnimator.conBackground
    readonly property color outline: colorAnimator.outline
    readonly property color outlineVariant: colorAnimator.outlineVariant
    readonly property color shadow: colorAnimator.shadow
    readonly property color scrim: colorAnimator.scrim
    readonly property color sourceColor: colorAnimator.sourceColor
}
