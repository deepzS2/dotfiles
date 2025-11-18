pragma Singleton

import QtQuick
import Quickshell
import qs.widgets
import qs.commons

Singleton {
    id: root

    property Component tooltipComponent: Component {
        Tooltip {}
    }

    property var tooltipInstance: null

    Component.onCompleted: {
        tooltipInstance = tooltipComponent.createObject(null);
        Logger.info("TooltipService", "Tooltip instance created");
    }

    function show(text, targetItem, options = {}) {
        if (!tooltipInstance) {
            Logger.error("TooltipService", "Tooltip instance not available");
            return;
        }

        if (!targetItem) {
            Logger.warn("TooltipService", "Invalid target item for tooltip");
            return;
        }

        Logger.debug("TooltipService", `Showing tooltip: "${text}"`);

        // Set tooltip properties from options
        tooltipInstance.alignment = options.alignment || "center";
        tooltipInstance.vertical = options.vertical || "auto";
        tooltipInstance.customMaxWidth = options.maxWidth || 300;
        tooltipInstance.additionalOffsetX = options.offsetX || 0;
        tooltipInstance.additionalOffsetY = options.offsetY || 0;
        tooltipInstance.forcePosition = options.forcePosition || false;

        // Hide any existing tooltip first
        if (tooltipInstance.visible)
            tooltipInstance.hideTooltip();

        tooltipInstance.showTooltip(text, targetItem);
    }

    function hide() {
        if (tooltipInstance?.visible) {
            Logger.debug("TooltipService", "Hiding tooltip");
            tooltipInstance.hideTooltip();
        }
    }
}
