import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import PavementJogger

Item {
    id: scrubber

    signal repaint()
    property int handleWidth: 15
    property int handleHeight: 15
    property int stemWidth: 2
    readonly property double screenX: (PJGlobalTimeline.scrubberPosition - PJGlobalTimeline.leftCutoff) / (PJGlobalTimeline.secondsPerPixel * PJGlobalTimeline.ticksPerSecond)

    MouseArea {
        id: mousearea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        // use ruler area to position scrubber
        onPositionChanged: {
            var adjMousePos = Math.max(0, Math.min(width, mouseX + PJGlobalTimeline.spacing/2));

            // adjust global left cutoff
            var projectedLeftCutoff = PJGlobalTimeline.leftCutoff;
            var scrollMargin = 100;
            var scrolled = false;
            if (adjMousePos < scrollMargin) {
                projectedLeftCutoff += (adjMousePos-scrollMargin) / 50;
                scrolled = true;
            }
            if (adjMousePos > width - scrollMargin) {
                projectedLeftCutoff += (adjMousePos-(width - scrollMargin)) / 50;
                scrolled = true;
            }
            projectedLeftCutoff = Math.max(0, projectedLeftCutoff);
            if (scrolled) {
                PJGlobalTimeline.leftCutoff = projectedLeftCutoff;
                scrubber.repaint();
            }

            // adjust global scrubber position
            var projectedPosition = PJGlobalTimeline.leftCutoff + adjMousePos * (PJGlobalTimeline.secondsPerPixel * PJGlobalTimeline.ticksPerSecond);
            var roundMultiple = PJGlobalTimeline.bigTickSignificance;
            projectedPosition = Math.round(projectedPosition / roundMultiple) * roundMultiple;
            PJGlobalTimeline.scrubberPosition = projectedPosition;
        }
    }

    Rectangle {
        id: box
        width: handleWidth
        height: parent.height
        anchors.top: parent.top
        color: "transparent"

        x: screenX - handleWidth/2

        property bool updating: false

        Shape {
            id: body
            anchors.fill: parent

            ShapePath {
                fillColor: "#3d4be6"
                strokeColor: "transparent"

                startX: 0; startY: 0
                PathLine { x: handleWidth; y: 0 }
                PathLine { x: handleWidth; y: handleHeight/2 }
                PathLine { x: handleWidth/2 + stemWidth/2; y: handleHeight }
                PathLine { x: handleWidth/2 + stemWidth/2; y: body.height }
                PathLine { x: handleWidth/2 - stemWidth/2; y: body.height }
                PathLine { x: handleWidth/2 - stemWidth/2; y: handleHeight }
                PathLine { x: 0; y: handleHeight/2 }
                PathLine { x: 0; y: 0 }
            }
        }

        DropShadow {
           anchors.fill: body
           source: body
           radius: 4
           samples: 9
           color: "black"
       }

    }

}
