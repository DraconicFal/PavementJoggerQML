import QtQuick
import PavementJogger

Item {
    id: tracks
    signal repaint
    property alias ruler: rulerDisplay

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#28282e"

        Rectangle {
            id: rulerArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true

            height: 50
            color: "#28282e"
            border.color: "#09090A"
            border.width: 1

            PJTimelineRuler {
                id: rulerDisplay
                anchors.fill: parent
            }
        }


        PJTimelineScrubber {
            id: scrubber
            anchors.fill: parent
            clip: PJGlobalTimeline.leftCutoff!==0
            onRepaint: () => tracks.repaint()
        }

    }
}
