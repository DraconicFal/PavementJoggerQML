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

        Rectangle {
            id: labelContainer
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            width: 200
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
        }

    }

}
