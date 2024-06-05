import QtQuick
import QtQuick.Controls
import PavementJogger

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

            Slider {
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.verticalCenter: parent.verticalCenter
                from: -1
                value: 0
                to: 6
                width: 200

                onValueChanged: {
                    PJGlobalTimeline.secondsPerPixel = Math.pow(2, value) / 200;
                    var canvas = tracks.ruler.canvas;
                    canvas.requestPaint();
                }
            }
        }

        PJTimelineLabels {
            id: labels
            width: 200
            anchors.top: title.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        PJTimelineTracks {
            id: tracks
            anchors.top: title.bottom
            anchors.bottom: parent.bottom
            anchors.left: labels.right
            anchors.right: parent.right
            onRepaint: () => ruler.canvas.requestPaint()
        }

    }

}
