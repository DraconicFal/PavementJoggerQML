import QtQuick
import QtQuick.Controls

Item {
    id: pj_timeline

    Rectangle {
        id: background
        color: "#29282E"
        anchors.fill: parent

        Rectangle {
            id: title
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#222127"
            border.color: "#09090A"
            border.width: 1.5

            Text {
                id: titleText
                text: qsTr("Timeline")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "white"
            }
        }

        PJTimelineArea {
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 200
        }

    }

}
