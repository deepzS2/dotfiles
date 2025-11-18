pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: logger

    enum Level {
        Debug,
        Info,
        Warn,
        Error
    }

    property int logLevel: Logger.Debug
    property bool enableConsoleLogging: true
    property bool enableFileLogging: false
    property string logFile: ""

    function debug(...args) {
        if (logLevel <= Logger.Debug) {
            console.log(_formatMessage("DEBUG:", ...args));
        }
    }

    function info(...args) {
        if (logLevel <= Logger.Info) {
            console.log(_formatMessage("INFO:", ...args));
        }
    }

    function warn(...args) {
        if (logLevel <= Logger.Warn) {
            console.log(_formatMessage("WARN:", ...args));
        }
    }

    function error(...args) {
        if (logLevel <= Logger.Error) {
            console.log(_formatMessage("ERROR:", ...args));
        }
    }

    function _formatMessage(level, ...args) {
        const maxLength = 14;
        const t = new Date().toLocaleTimeString(Qt.locale(), "HH:mm:ss");

        const module = level.substring(0, maxLength).padEnd(maxLength, " ");
        const message = args.join(" ");

        return `\x1b[36m[${t}]\x1b[0m \x1b[35m${module}\x1b[0m ${message}`;
    }
}
