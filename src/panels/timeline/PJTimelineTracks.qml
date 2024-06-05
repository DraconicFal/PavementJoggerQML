import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: tracks
    signal repaint
    property alias flickable: trackFlickable

    Flickable {
        id: trackFlickable
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.bottomMargin: 5

        contentWidth: goofyaahlabel.width
        contentHeight: goofyaahlabel.height

        boundsBehavior: Flickable.StopAtBounds
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
                PJGlobalTimeline.leftCutoff = contentX*PJGlobalTimeline.ticksPerPixel;
                repaint();
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
            text: "G. g. marquez"
            font.pixelSize: 224
        }

        // scroll bars
        ScrollBar.vertical: ScrollBar {
            width: 7.5
            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
            interactive: true
        }

        ScrollBar.horizontal: ScrollBar {
            height: 7.5
            anchors.bottom: parent.bottom
            policy: ScrollBar.AsNeeded
            interactive: true
        }
    }


}
