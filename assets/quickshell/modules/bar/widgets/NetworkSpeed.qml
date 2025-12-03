import QtQuick
import qs.commons
import qs.widgets
import qs.modules.bar.services

Rectangle {
    id: root

    implicitWidth: speedText.implicitWidth + Styles.widgetPadding * 2
    implicitHeight: Styles.capsuleHeight
    radius: Styles.widgetRadius
    color: NetworkingService.isConnected ? Styles.widgetBackground : Styles.warningColor
    opacity: Styles.widgetOpacity

    border {
        width: Styles.widgetBorderWidth
        color: NetworkingService.isConnected ? Styles.widgetBorder : Styles.warningColor
    }

    // Shadow effect
    DropShadow {
        anchors.fill: parent
        source: root
    }

    Text {
        id: speedText
        anchors.centerIn: parent
        text: `${NetworkingService.bandwidthDownBits}  | ${NetworkingService.bandwidthUpBits} `
        font: Styles.systemFont
        color: NetworkingService.isConnected ? Styles.widgetForeground : Styles.widgetBackground
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            const tooltip = !NetworkingService.isConnected
                ? "Not Connected to any type of Network"
                : NetworkingService.connectionType === "wifi"
                ? `${NetworkingService.essid} (${NetworkingService.signalStrength}%)   \n${NetworkingService.ipAddress}`
                : NetworkingService.connectionType === "ethernet"
                ? `${NetworkingService.interfaceName} 󰈀 \n${NetworkingService.ipAddress}`
                : NetworkingService.ipAddress;
            TooltipService.show(tooltip, root);
        }
        onExited: TooltipService.hide()
    }

    // Initialize
    Component.onCompleted: {
        Logger.info("NetworkSpeed", "Network speed widget initialized");
    }
}