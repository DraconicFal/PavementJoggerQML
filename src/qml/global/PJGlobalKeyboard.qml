pragma Singleton
import QtQuick

Item {

    /////////////////////////////
    // GET KEY PRESS FUNCTIONS //
    /////////////////////////////
    property bool shiftPressed: false
    property bool ctrlPressed: false
    property bool backspacePressed: false
    property bool deletePressed: false


    function getShiftPressed() {
        return internal.getEventExists() && (internal.event.modifiers & Qt.ShiftModifier);
    }
    function getCtrlPressed() {
        return internal.getEventExists() && (internal.event.modifiers & Qt.ControlModifier);
    }
    function getBackspacePressed() {
        return internal.getEventExists() && (internal.event.key === Qt.Key_Backspace);
    }
    function getDeletePressed() {
        return internal.getEventExists() && (internal.event.key === Qt.Key_Delete);
    }


    //////////////
    // INTERNAL //
    //////////////
    function setEvent(event) {
        internal.event = event;
    }
    function processEvent(event, pressed) {
        // Modifiers
        if (event.modifiers & Qt.ShiftModifier) {
            shiftPressed = true;
        } else shiftPressed = false;

        if (event.modifiers & Qt.ControlModifier) {
            ctrlPressed = pressed;
        } else ctrlPressed = false;

        // Keycodes
        switch (event.key) {
        case Qt.Key_Backspace:
            backspacePressed = pressed;
            break;
        case Qt.Key_Delete:
            deletePressed = pressed;
            break;
        default:
            break;
        }
    }

    QtObject {
        id: internal
        property var event
        function getEventExists() {
            return typeof(internal.event) !== "undefined"
        }

        onEventChanged: {
            console.log(`Key event: ${event}, key: ${event.key}, backspace: ${Qt.Key_Backspace}, del: ${Qt.Key_Delete}, getBackspacePressed: ${PJGlobalKeyboard.backspacePressed}`);
            console.log(`Event exists: ${getEventExists()}`);
        }

    }

}
