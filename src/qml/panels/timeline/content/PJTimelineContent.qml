import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: content
    property alias ruler: ruler
    property alias scrubber: scrubber
    property alias tracks: tracks

    signal repaintTimeline()
    function repaint() {
        ruler.repaint();
        tracks.repaint();
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#28282e"

        PJTimelineRuler {
            id: ruler
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            z: 1

            // Propagate Repaint Upwards
            onRepaintTimeline: content.repaintTimeline()
        }

        PJTimelineScrubber {
            id: scrubber
            anchors.fill: parent
            clip: !(PJGlobalTimeline.leftPixelCutoff <= scrubber.stemWidth)
            z: 2

            // Propagate Repaint Upwards
            onRepaintTimeline: content.repaintTimeline()
        }

        PJTimelineTracks {
            id: tracks
            anchors.top: ruler.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true
            z: 0

            // Propagate Repaint Upwards
            onRepaintTimeline: content.repaintTimeline()
        }

    }

}
