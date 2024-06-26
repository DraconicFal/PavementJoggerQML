import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: content
    signal repaint()
    property alias ruler: ruler

    function resizeTracks() {
        tracks.flickable.contentWidth = PJGlobalTimeline.timelinePixelLength;
        tracks.canvas.width = PJGlobalTimeline.timelinePixelLength;
        tracks.canvas.requestPaint();
    }

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
            z: 1

            height: 50
            color: "#28282e"
            border.color: "#09090A"
            border.width: 1

            PJTimelineRuler {
                id: ruler
                anchors.fill: parent

                onResizeTracks: content.resizeTracks()
            }
        }


        PJTimelineScrubber {
            id: scrubber
            anchors.fill: parent
            clip: !(PJGlobalTimeline.leftPixelCutoff <= scrubber.stemWidth)
            z: 2

            onRepaint: {
                () => content.repaint()
                tracks.flickable.contentX = PJGlobalTimeline.leftTickCutoff/PJGlobalTimeline.ticksPerPixel;
            }

            onResizeTracks: content.resizeTracks()
        }

        PJTimelineTracks {
            id: tracks
            anchors.top: rulerArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true
            z: 0

            onRepaint: {
                ruler.canvas.requestPaint();
                flickable.contentWidth = Math.max(flickable.contentWidth, PJGlobalTimeline.leftTickCutoff)
            }

            onResizeTracks: content.resizeTracks()
        }

    }
}
