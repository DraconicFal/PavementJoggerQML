pragma Singleton
import QtQuick

Item {

    ///////////////////////
    // READABLE BOOLEANS //
    ///////////////////////
    readonly property bool shiftPressed: internal.eventExists && (internal.event.modifiers & Qt.ShiftModifier)
    readonly property bool ctrlPressed: internal.eventExists && (internal.event.modifiers & Qt.ControlModifier)


    //////////////
    // INTERNAL //
    //////////////
    function setEvent(event) {
        internal.event = event;
    }
    QtObject {
        id: internal
        property var event
        property bool eventExists: typeof internal.event !== "undefined"
    }

}
