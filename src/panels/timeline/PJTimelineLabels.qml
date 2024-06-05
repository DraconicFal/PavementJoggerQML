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
                    var position = PJGlobalTimeline.scrubberTickPosition;
                    var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;

                    var millis = String(1000 * (position % ticksPerSecond) / ticksPerSecond).padStart(3, '0');
                    var seconds = String(Math.floor(position / ticksPerSecond) % 60).padStart(2, '0');
                    var minutes = String(Math.floor(position / ticksPerSecond / 60) % 60).padStart(2, '0');
                    var hours = String(Math.floor(position / ticksPerSecond / 3600)).padStart(2, '0');
                    return hours + ":" + minutes + ":" + seconds + "." + millis;
                }

                anchors.centerIn: parent
                text: getScrubberText()

                color: "#c4c4c5"
                font.bold: true
                font.pointSize: 18
            }
        }

    }
}
