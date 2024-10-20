import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: scrubberText

    Rectangle {
        id: background
        anchors.fill: parent
        clip: true

        color: "transparent"
        border.color: "#09090A"
        border.width: 1

        Label {
            id: label

            anchors.centerIn: parent
            text: PJGlobalTimeline.getTimestampText(PJGlobalTimeline.scrubberTickPosition)

            color: "#c4c4c5"
            font.bold: true
            font.pointSize: 18
        }
    }
}
