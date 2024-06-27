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
                id: zoomSlider
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.verticalCenter: parent.verticalCenter
                from: -1
                value: 0
                to: 6
                width: 200

                background: Rectangle {
                    x: zoomSlider.leftPadding
                    y: zoomSlider.topPadding + zoomSlider.availableHeight / 2 - height / 2
                    implicitHeight: 4
                    width: zoomSlider.availableWidth
                    height: implicitHeight
                    radius: height/2
                    color: "#141414"

                    border.color: "#2c2c34"
                    border.width: 0.5
                }

                handle: Rectangle {
                    x: zoomSlider.leftPadding + zoomSlider.visualPosition * (zoomSlider.availableWidth - width)
                    y: zoomSlider.topPadding + zoomSlider.availableHeight / 2 - height / 2
                    implicitWidth: 11
                    implicitHeight: width
                    radius: width/2
                    color: "#878787"

                    border.color: "#1c1c1f"
                    border.width: 1

                    Rectangle {
                        anchors.centerIn: parent
                        implicitWidth: 5
                        implicitHeight: width
                        radius: width/2
                        color: zoomSlider.pressed ? "#5c5c5c" : "#878787"
                    }
                }

                onValueChanged: {
                    PJGlobalTimeline.secondsPerPixel = Math.pow(2, value) / 200;
                    var canvas = content.ruler.canvas;
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

        PJTimelineContent {
            id: content
            anchors.top: title.bottom
            anchors.bottom: parent.bottom
            anchors.left: labels.right
            anchors.right: parent.right
            onRepaint: () => ruler.canvas.requestPaint()
        }

    }

}
