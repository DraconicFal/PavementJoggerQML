import QtQuick

Item {
    id: draggable_Obj
    Rectangle {
        id: baseColor
        width: 100
        height: 50
        color: "red"

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 1000
        Drag.hotSpot.y: 1000

        //Drag.activeChanged:


        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent
        }
    }
}
