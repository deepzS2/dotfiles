import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons
import qs.widgets

Rectangle {
    id: root

    // Layout properties
    implicitWidth: brightnessText.implicitWidth + Styles.widgetPadding * 2
    implicitHeight: Styles.capsuleHeight
    radius: Styles.widgetRadius
    color: Styles.widgetBackground
    opacity: Styles.widgetOpacity

    // Border styling
    border {
        width: Styles.widgetBorderWidth
        color: Styles.widgetBorder
    }

    // Shadow effect
    DropShadow {
        anchors.fill: parent
        source: root
    }

    // Brightness properties
    property int currentBrightness: 0
    property int maxBrightness: 100
    property int targetBrightness: 0
    property string text: ""
    property string tooltipText: ""
    readonly property var icons: ["󱃓", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥", "󰖨"]

    // File paths
    property string backlightDevice: ""
    readonly property string brightnessFilePath: backlightDevice ? `/sys/class/backlight/${backlightDevice}/brightness` : ""
    readonly property string maxBrightnessFilePath: backlightDevice ? `/sys/class/backlight/${backlightDevice}/max_brightness` : ""

    Text {
        id: brightnessText
        anchors.centerIn: parent
        text: root.text
        font: Styles.systemFont
        color: Styles.widgetForeground
    }

    Timer {
        id: applyBrightnessTimer
        interval: 100
        onTriggered: () => root.applyBrightnessChange()
    }

    // Device detection
    Process {
        id: detectDeviceProcess
        command: ["ls", "/sys/class/backlight/"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const devices = this.text.trim().split('\n').filter(device => device.length > 0);
                if (devices.length > 0) {
                    root.backlightDevice = devices[0];
                }
            }
        }
    }

    // Max brightness file monitor
    FileView {
        id: maxBrightnessFile
        path: root.maxBrightnessFilePath
        watchChanges: path.length > 0
        preload: true
        blockLoading: true
    }

    // Current brightness file monitor
    FileView {
        id: brightnessFile
        path: root.brightnessFilePath
        watchChanges: path.length > 0
        onLoaded: () => root.updateBrightness()
        onFileChanged: () => root.updateBrightness()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: TooltipService.show(root.tooltipText, root)
        onExited: TooltipService.hide()
        onWheel: wheel => root.handleWheelEvent(wheel)
    }

    function updateBrightness() {
        brightnessFile.reload();
        root.currentBrightness = parseInt(brightnessFile.text().trim()) || 0;
        root.maxBrightness = parseInt(maxBrightnessFile.text().trim()) || 100;

        updateDisplay(root.currentBrightness, root.maxBrightness);
    }

    function updateDisplay(current, max) {
        const percentage = Math.round((current / max) * 100);
        const iconIndex = Math.min(9, Math.floor(percentage / 10));

        root.text = `${root.icons[iconIndex]} ${percentage}%`;
        root.tooltipText = `Brightness: ${current}/${max} (${percentage}%)`;
    }

    function handleWheelEvent(wheel) {
        const delta = wheel.angleDelta.y > 0 ? 1 : -1;
        const brightness = root.targetBrightness || root.currentBrightness;

        root.targetBrightness = brightness + delta;

        applyBrightnessTimer.start();
    }

    function applyBrightnessChange() {
        const clampedBrightness = Math.max(0, Math.min(root.maxBrightness, root.targetBrightness));
        root.targetBrightness = clampedBrightness;

        if (applyBrightnessTimer.running) {
            return;
        }

        Quickshell.execDetached(["brightnessctl", "set", clampedBrightness.toString()]);
    }
}
