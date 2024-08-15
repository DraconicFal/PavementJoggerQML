import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: tracks

    signal repaintTimeline()
    function repaint() {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        objectName: "timelineTracks"
        anchors.fill: parent

        function drawVerticalBars(ctx) {
            // calculate the start positions of the ruler
            var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;
            var pixelsPerTick = bigTickSignificance*bigTickSignificance/PJGlobalTimeline.ticksPerPixel;
            var leftCutoff = PJGlobalTimeline.leftTickCutoff;
            var startPixel = -pixelsPerTick * (leftCutoff%bigTickSignificance)/bigTickSignificance;
            var startTick = Math.floor(leftCutoff / bigTickSignificance);

            // render vertical bars
            var width = 0.25;
            var totalTicks = PJGlobalTimeline.totalTicks;
            var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;
            ctx.fillStyle = "#6f6f6f";
            for (var i = -ticksPerSecond + 1; i < Math.ceil(totalTicks) + ticksPerSecond; i++) {
                var modTick = (startTick + i) % ticksPerSecond;
                if (modTick===0) {
                    // Big Ticks
                    ctx.fillRect(startPixel + i*pixelsPerTick - width/2, 0, width, canvas.height);
                }
            }
        }

        function drawHorizontalLines(ctx) {
            // get the start position and spacing
            var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
            var trackHeight = PJGlobalTimeline.trackHeight;

            // render horizontal lines
            var exteriorWidth = 2;
            var interiorWidth = 1;
            var startPixel = verticalPixelScroll % trackHeight - trackHeight;
            var n = PJGlobalTimeline.tracks.length + 2;
            for (var i = 0; i < n; i++) {
                ctx.fillStyle = "#030303";
                ctx.fillRect(0, startPixel-exteriorWidth/2, canvas.width, exteriorWidth);
                ctx.fillStyle = "#484848";
                ctx.fillRect(0, startPixel-interiorWidth/2, canvas.width, interiorWidth);
                startPixel += trackHeight;
            }
        }

        onPaint: {
            // Get context and reset canvas
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Render tracks background
            PJGlobalTimeline.trackPixelWidth = tracks.width;
            PJGlobalTimeline.trackPixelHeight = tracks.height;
            drawHorizontalLines(ctx);
            drawVerticalBars(ctx);
        }

        // Handle clearing selection by clicking on the timeline
        MouseArea {
            id: timelineClickArea
            anchors.fill: parent
            propagateComposedEvents: true

            onPressed: function(mouse) {
                PJGlobalTimeline.timelinePressed = true;
            }
            onReleased: function(mouse) {
                PJGlobalTimeline.timelinePressed = false;
            }
        }

    }

}
