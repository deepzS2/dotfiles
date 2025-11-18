import QtQuick
import Quickshell
import qs.commons
import qs.widgets

Rectangle {
    id: distroWidget

    implicitWidth: distroText.implicitWidth + Styles.widgetPadding * 2
    implicitHeight: Styles.capsuleHeight
    radius: Styles.widgetRadius
    color: Styles.widgetBackground
    opacity: Styles.widgetOpacity

    border {
        width: Styles.widgetBorderWidth
        color: Styles.widgetBorder
    }

    // Shadow effect
    DropShadow {
        anchors.fill: parent
        source: distroWidget
    }

    Text {
        id: distroText
        anchors.centerIn: parent
        text: ""
        font: Styles.systemFontBig
        color: Styles.base0D
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached(["rofi", "-show", "drun", "-theme", "~/.config/rofi/launcher.rasi"]);
        }
    }
}
