import QtQuick

Item {
    id: fVRobot

    function move (moveAmount, direction) {
        if (direction === "horizontal") {
            fVRobot.x += moveAmount;
        }
        else if (direction === "vertical") {
            fVRobot.y += moveAmount;
        }
    }

    Image {
        width: parent.width
        height: parent.height
        source: "qrc:/Images/assets/STEPHEN.jpg"
        z: 100
        //anchors.alignWhenCentered: parent
    }

}
