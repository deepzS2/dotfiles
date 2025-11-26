import QtQuick
import qs.commons
import qs.widgets
import qs.modules.bar.services

Rectangle {
    id: root

    implicitWidth: networkText.implicitWidth + Styles.widgetPadding * 2
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
        id: networkText
        anchors.centerIn: parent
        text: NetworkingService.isConnected ? `${NetworkingService.networkIcon}  ${NetworkingService.bandwidthTotalBytes}/s` : "󱐅  Disc"
        font: Styles.systemFont
        color: NetworkingService.isConnected ? Styles.widgetForeground : Styles.widgetBackground
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onEntered: {
            const tooltip = !NetworkingService.isConnected ? "Disconnected" : NetworkingService.connectionType === "wifi" ? `${NetworkingService.essid} (${NetworkingService.signalStrength}%)   | ${NetworkingService.ipAddress}` : NetworkingService.connectionType === "ethernet" ? `${NetworkingService.interfaceName} 🖧  | ${NetworkingService.ipAddress}` : NetworkingService.ipAddress;
            TooltipService.show(tooltip, root);
        }
        onExited: TooltipService.hide()

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                NetworkingService.launchWifiMenu();
            } else if (mouse.button === Qt.RightButton) {
                NetworkingService.launchNetworkManager();
            }
        }
    }

    // Initialize
    Component.onCompleted: {
        Logger.info("Network", "Network widget initialized");
    }
}
