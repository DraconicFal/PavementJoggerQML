import QtQuick
import QtQuick.Controls
import PavementJogger


Item {
    id: labels

    signal repaintTimeline()
    function repaint() {
        trackLabels.repaint();
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#212126"

        PJTimelineScrubberLabel {
            id: scrubberLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
        }

        PJTimelineTrackLabels {
            id: trackLabels
            anchors.top: scrubberLabel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            // Propagate Repaint Upwards
            onRepaintTimeline: labels.repaintTimeline()
        }

    }
}
