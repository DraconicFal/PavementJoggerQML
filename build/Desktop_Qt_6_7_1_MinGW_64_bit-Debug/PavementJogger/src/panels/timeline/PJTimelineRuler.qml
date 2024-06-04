import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: ruler
    property alias canvas: rulerCanvas

    Canvas {
        id: rulerCanvas
        anchors.fill: parent

        function getTimestampText(position) {
            var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;

            var millis = String(1000 * (position % ticksPerSecond) / ticksPerSecond).padStart(3, '0');
            var seconds = String(Math.floor(position / ticksPerSecond) % 60).padStart(2, '0');
            var minutes = String(Math.floor(position / ticksPerSecond / 60) % 60).padStart(2, '0');
            var hours = String(Math.floor(position / ticksPerSecond / 3600)).padStart(2, '0');
            return hours + ":" + minutes + ":" + seconds + "." + millis;
        }

        onPaint: {
            // get context and reset canvas
            const ctx = getContext("2d");
            context.clearRect(0, 0, canvas.width, canvas.height);
            var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;
            var minSpacing = PJGlobalTimeline.minSpacing;
            var position = PJGlobalTimeline.scrubberPosition;
            var secondsPerPixel = PJGlobalTimeline.secondsPerPixel;

            // calculate Big Tick Significance
            var secondsOnScreen = parent.width * secondsPerPixel;
            var totalTicks = secondsOnScreen * ticksPerSecond;
            var bigTickSignificance = 1;
            while (parent.width / totalTicks < minSpacing) {
                bigTickSignificance *= 2.0;
                totalTicks /= 2.0;
            }
            PJGlobalTimeline.bigTickSignificance = bigTickSignificance;

            // calculate pixels per tick
            var pixelsPerBigTick = 1 / secondsPerPixel * bigTickSignificance;
            var pixelsPerTick = pixelsPerBigTick / ticksPerSecond;
            PJGlobalTimeline.spacing = pixelsPerTick;

            // calculate the start positions for the ruler
            var leftCutoff = PJGlobalTimeline.leftCutoff;
            var startPixel = -pixelsPerTick * ((leftCutoff / bigTickSignificance) % ticksPerSecond);
            var startTick = Math.floor(PJGlobalTimeline.leftCutoff / bigTickSignificance);

            // render ruler with padding
            ctx.font = "12px sans-serif";
            for (var i = 0; i < Math.ceil(totalTicks) + ticksPerSecond; i++) {
                var width = 0.75;
                var height;
                var rect = true;
                var modTick = i % ticksPerSecond;
                if (modTick===0) {
                    // Big Ticks
                    height = 27;
                    ctx.fillStyle = Qt.rgba(1, 1, 1, 0.6);
                    rect = false;

                    // label Big Ticks
                    ctx.fillStyle = "#8f8f8f";
                    ctx.fillText(
                        getTimestampText(startTick - (startTick % ticksPerSecond) + i * bigTickSignificance),
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

        }
    }

}
