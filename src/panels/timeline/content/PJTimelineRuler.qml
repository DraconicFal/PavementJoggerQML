import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: ruler

    signal repaintTimeline()
    function repaint() {
        canvas.requestPaint();
    }

    Rectangle {
        id: background
        anchors.fill: parent
        clip: true

        color: "transparent"
        border.color: "#09090A"
        border.width: 1

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                // get context and reset canvas
                const ctx = getContext("2d");
                context.clearRect(0, 0, canvas.width, canvas.height);
                var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;
                var minSpacing = PJGlobalTimeline.minSpacing;
                var position = PJGlobalTimeline.scrubberTickPosition;
                var secondsPerPixel = PJGlobalTimeline.secondsPerPixel;

                // calculate Big Tick Significance
                var secondsOnScreen = parent.width * secondsPerPixel;
                var totalTicks = secondsOnScreen * ticksPerSecond;
                var bigTickSignificance = 1;
                while (parent.width / totalTicks < minSpacing) {
                    bigTickSignificance *= 2.0;
                    totalTicks /= 2.0;
                }
                PJGlobalTimeline.totalTicks = totalTicks;
                PJGlobalTimeline.bigTickSignificance = bigTickSignificance;

                // calculate pixels per tick
                var pixelsPerBigTick = 1 / secondsPerPixel * bigTickSignificance;
                var pixelsPerTick = pixelsPerBigTick / ticksPerSecond;
                PJGlobalTimeline.spacing = pixelsPerTick;

                // calculate the start positions for the ruler
                var leftCutoff = PJGlobalTimeline.leftTickCutoff;
                var startPixel = -pixelsPerTick * (leftCutoff%bigTickSignificance)/bigTickSignificance;
                var startTick = Math.floor(leftCutoff / bigTickSignificance);

                // render ruler with padding
                ctx.font = "12px sans-serif";
                for (var i = -ticksPerSecond + 1; i < Math.ceil(totalTicks) + ticksPerSecond; i++) {
                    var width = 0.75;
                    var height;
                    var rect = true;
                    var modTick = (startTick + i) % ticksPerSecond;
                    if (modTick===0) {
                        // Big Ticks
                        height = 27;
                        ctx.fillStyle = "#ffffff";
                        rect = false;

                        // label Big Ticks
                        ctx.fillStyle = "#8f8f8f";
                        ctx.fillText(
                            PJGlobalTimeline.getTimestampText((startTick + i) * bigTickSignificance),
                            startPixel + i*pixelsPerTick + 0.75*minSpacing,
                            27
                        );
                    }
                    else if (2*modTick % ticksPerSecond===0) {
                        // Midpoint Ticks
                        height = 17;
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.175);
                    }
                    else if (modTick % 2===0) {
                        // Even Ticks
                        height = 12;
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.075);
                    }
                    else {
                        // Odd Ticks
                        height = 7;
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.075);
                    }
                    if (rect) {
                        ctx.fillRect(startPixel + i*pixelsPerTick - width/2, 0, width, height);
                    } else {
                        ctx.beginPath();
                        ctx.moveTo(startPixel + i*pixelsPerTick - width/2, 0);
                        ctx.lineTo(startPixel + i*pixelsPerTick, height);
                        ctx.lineTo(startPixel + i*pixelsPerTick + width/2, 0);
                        ctx.fill();
                    }
                }

                var leftPixelCutoff = PJGlobalTimeline.leftPixelCutoff;
                PJGlobalTimeline.rightPixelCutoff = leftPixelCutoff + ruler.width;

                // propagate an update upwards
                ruler.repaintTimeline();
            }

        }

    }

}
