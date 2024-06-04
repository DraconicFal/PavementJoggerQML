import QtQuick
import QtQuick.Controls


Item {
    id: timelineArea

    Rectangle {
        id: labelContainer
        anchors.fill: parent
        color: "#212126"

        Rectangle {
            id: scrubberTimeText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 40
            color: "#212126"
            border.color: "#09090A"
            border.width: 1.25

            Label {
                anchors.centerIn: parent
                text: "0:00:00:00"
                color: "white"
                font.bold: true
                font.pointSize: 18
            }
        }

        Gauge {

        }
    }
}
