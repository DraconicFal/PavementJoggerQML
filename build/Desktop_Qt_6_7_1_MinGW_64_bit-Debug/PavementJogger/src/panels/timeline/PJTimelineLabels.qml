import QtQuick
import QtQuick.Controls
import PavementJogger


Item {
    id: labels

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#212126"

        Rectangle {
            id: scrubberTimeText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true

            height: 50
            color: "#212126"
            border.color: "#09090A"
            border.width: 1

            Label {
                function getScrubberText() {
                    var position = PJGlobalTimeline.scrubberPosition;
                    var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;

                    var frames = String(position % ticksPerSecond).padStart(2, '0');
                    var seconds = String(Math.floor(position / ticksPerSecond) % 60).padStart(2, '0');
                    var minutes = String(Math.floor(position / ticksPerSecond / 60) % 60).padStart(2, '0');
                    var hours = String(Math.floor(position / ticksPerSecond / 3600)).padStart(2, '0');
                    return hours + ":" + minutes + ":" + seconds + ":" + frames;
                }

                anchors.centerIn: parent
                text: getScrubberText()

                color: "white"
                font.bold: true
                font.pointSize: 18
            }
        }

    }
}
