import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: tracks
    signal repaint
    property alias ruler: ruler

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
            }
        }


        PJTimelineScrubber {
            id: scrubber
            anchors.fill: parent
            clip: PJGlobalTimeline.leftCutoff!==0
            z: 2

            onRepaint: {
                () => tracks.repaint()
                trackFlickable.contentX = PJGlobalTimeline.leftCutoff/(PJGlobalTimeline.bigTickSignificance*PJGlobalTimeline.ticksPerSecond*PJGlobalTimeline.secondsPerPixel);
            }
        }

        Rectangle {
            id: trackArea
            anchors.top: rulerArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true
            z: 0

            Flickable {
                id: trackFlickable
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: Math.max(goofyaahlabel.width, contentX+parent.width)
                contentHeight: goofyaahlabel.height
                maximumFlickVelocity: 0

                // disable drag
                property double dragStartX
                property double dragStartY

                onDragStarted: {
                    dragStartX = contentX;
                    dragStartY = contentY;
                    contentX = dragStartX;
                    contentY = dragStartY;
                }
                onContentXChanged: {
                    if (!dragging) {
                        PJGlobalTimeline.leftCutoff = contentX * (PJGlobalTimeline.bigTickSignificance*PJGlobalTimeline.ticksPerSecond*PJGlobalTimeline.secondsPerPixel);
                        ruler.canvas.requestPaint();
                    } else {
                        contentX = dragStartX;
                    }
                }
                onContentYChanged: {
                    if (dragging) {
                        contentY = dragStartY;
                    }
                }

                // actual content
                Label {
                    id: goofyaahlabel
                    text: "This is the area for all the tracks it's not implemented yet aaaaah\ndoes newline work ooooo"
                    font.pixelSize: 224
                }

                ScrollBar.vertical: ScrollBar {
                    width: 10
                    anchors.right: parent.right
                    policy: ScrollBar.AsNeeded
                    interactive: true
                }

                ScrollBar.horizontal: ScrollBar {
                    height: 10
                    anchors.bottom: parent.bottom
                    policy: ScrollBar.AsNeeded
                    interactive: true
                }
            }
        }

    }
}
