import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: timeline
    signal repaintTimeline()
    property alias labels: labels
    property alias content: content

    onRepaintTimeline: {
        labels.repaint();
        content.repaint();
    }

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

            PJTimelineZoomSlider {
                id: zoomSlider
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.verticalCenter: parent.verticalCenter
                width: 200

                // Propagate Repaint Upward
                onRepaintTimeline: timeline.repaintTimeline()
            }
        }

        PJTimelineLabels {
            id: labels
            width: 200
            anchors.top: title.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            // Propagate Repaint Upward
            onRepaintTimeline: timeline.repaintTimeline()
        }

        PJTimelineContent {
            id: content
            anchors.top: title.bottom
            anchors.bottom: parent.bottom
            anchors.left: labels.right
            anchors.right: parent.right

            // Propagate Repaint Upward
            onRepaintTimeline: timeline.repaintTimeline()
        }

        PJTimelineScrollArea {
            id: scrollArea
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height - (title.height + content.ruler.height)

            // Propagate Repaint Upward
            onRepaintTimeline: timeline.repaintTimeline()
        }

    }

}
