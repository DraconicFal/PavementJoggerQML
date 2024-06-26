import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: tracks
    signal repaint()
    signal resizeTracks()
    property alias flickable: flickable
    property alias canvas: canvas


    Flickable {
        id: flickable
        anchors.fill: parent

        contentHeight: canvas.height

        boundsBehavior: Flickable.StopAtBounds
        maximumFlickVelocity: 0

        //////////////////
        // DISABLE DRAG //
        //////////////////
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
                PJGlobalTimeline.leftTickCutoff = contentX*PJGlobalTimeline.ticksPerPixel;
                PJGlobalTimeline.rightTickCutoff = PJGlobalTimeline.leftTickCutoff + tracks.width;
                tracks.repaint();

                // propagate an update upwards
                tracks.resizeTracks();

            } else {
                contentX = dragStartX;
            }
        }
        onContentYChanged: {
            if (dragging) {
                contentY = dragStartY;
            }
        }


        ////////////////////
        // ACTUAL CONTENT //
        ////////////////////
        Canvas {
            id: canvas
            width: 3000
            height: 500

            onPaint: {
                // get context and reset canvas
                const ctx = getContext("2d");
                context.clearRect(0, 0, canvas.width, canvas.height);

                ctx.fillStyle = "#8f8f8f";
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                PJGlobalTimeline.trackPixelLength = goofyaahlabel.width;
            }

            Label {
                id: goofyaahlabel
                text: "gatimala city\n good game marquez"
                font.pixelSize: 224
            }
        }


        /////////////////
        // SCROLL BARS //
        /////////////////
        ScrollBar.vertical: ScrollBar {
            height: 40
            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
            visible: true
        }

        ScrollBar.horizontal: ScrollBar {
            width: 40
            anchors.bottom: parent.bottom
            policy: ScrollBar.AsNeeded
            visible: true
        }
    }


}
