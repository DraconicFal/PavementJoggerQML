pragma Singleton
import QtQuick

Item {

    ///////////////////////
    // READABLE BOOLEANS //
    ///////////////////////
    readonly property bool shiftPressed: internal.event && (internal.event.modifiers & Qt.ShiftModifier)
    readonly property bool ctrlPressed: internal.event && (internal.event.modifiers & Qt.ControlModifier)


    //////////////
    // INTERNAL //
    //////////////
    function setEvent(event) {
        internal.event = event;
    }
    QtObject {
        id: internal
        property var event: false
    }

}
