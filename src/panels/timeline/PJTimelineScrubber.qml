import QtQuick
import QtQuick.Shapes
import PavementJogger

Item {
    id: scrubber

    signal repaint()
    signal resizeTracks()
    property int handleWidth: 15
    property int handleHeight: 15
    property int stemWidth: 2
    readonly property double screenX: (PJGlobalTimeline.scrubberTickPosition - PJGlobalTimeline.leftTickCutoff) / (PJGlobalTimeline.secondsPerPixel * PJGlobalTimeline.ticksPerSecond)

    MouseArea {
        id: mousearea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        function updateScrubber() {
            var adjMousePos = mouseX;
            adjMousePos = Math.max(0, Math.min(width, adjMousePos));
            var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;

            // adjust global left cutoff
            var projectedLeftCutoff = PJGlobalTimeline.leftTickCutoff;
            var scrollMargin = 100;
            var scrolled = false;
            if (adjMousePos < scrollMargin) {
                projectedLeftCutoff += bigTickSignificance * (adjMousePos-scrollMargin) / 100;
                scrolled = true;
            }
            if (adjMousePos > width - scrollMargin) {
                projectedLeftCutoff += bigTickSignificance *(adjMousePos-(width - scrollMargin)) / 100;
                scrolled = true;
            }
            projectedLeftCutoff = Math.max(0, projectedLeftCutoff);
            if (scrolled) {
                PJGlobalTimeline.leftTickCutoff = projectedLeftCutoff;
                scrubber.repaint();
            }

            // adjust global scrubber position
            var projectedPosition = PJGlobalTimeline.leftTickCutoff + adjMousePos * (PJGlobalTimeline.secondsPerPixel * PJGlobalTimeline.ticksPerSecond);
            projectedPosition = Math.round(projectedPosition / bigTickSignificance) * bigTickSignificance;
            PJGlobalTimeline.scrubberTickPosition = projectedPosition;

            // propagate an update upwards
            scrubber.resizeTracks();
        }

        // use ruler area to position scrubber
        onClicked: updateScrubber()
        onPressed: updateScrubber()
        onPositionChanged: updateScrubber()

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
                fillColor: "#38b6ff"
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

    }

}
