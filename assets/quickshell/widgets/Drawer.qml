pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.commons

// Reusable drawer component that expands from right-to-left
// Shows only first child when collapsed, all children when expanded
Item {
    id: root

    // Default properties
    default property alias children: content.children
    property int direction: Qt.LeftToRight
    property bool expanded: false
    property int animationDuration: 500

    implicitWidth: expanded ? content.implicitWidth : (content.children.length > 0 ? content.children[0].implicitWidth : 0)
    implicitHeight: Styles.capsuleHeight
    clip: true

    // Content container with horizontal layout
    RowLayout {
        id: content
        layoutDirection: root.direction
        anchors.fill: parent
        spacing: Styles.widgetSpacing
    }

    // Animation for width changes
    Behavior on implicitWidth {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    // HoverHandler to toggle expansion
    // MouseArea was not working properly for the children items
    HoverHandler {
        onHoveredChanged: root.expanded = hovered
    }

    // Initialize
    Component.onCompleted: {
        Logger.info("Drawer", "Drawer component initialized");
    }
}
