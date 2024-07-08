import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: tracks
    signal repaint()
    signal resizeTracks()
    property alias canvas: canvas

    Canvas {
        id: canvas
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
            for (var i = -ticksPerSecond + 1; i < Math.ceil(totalTicks) + ticksPerSecond; i++) {
                var modTick = (startTick + i) % ticksPerSecond;
                if (modTick===0) {
                    // Big Ticks
                    ctx.fillStyle = "#8f8f8f";
                    ctx.fillRect(startPixel + i*pixelsPerTick - width/2, 0, width, canvas.height);
                }
            }
        }

        function roundRect(ctx, x, y, w, h, radius) {
            var r = x + w;
            var b = y + h;
            ctx.beginPath();
            ctx.strokeStyle="#212229";
            ctx.fillStyle="gray";
            ctx.lineWidth="2";
            ctx.moveTo(x+radius, y);
            ctx.lineTo(r-radius, y);
            ctx.quadraticCurveTo(r, y, r, y+radius);
            ctx.lineTo(r, y+h-radius);
            ctx.quadraticCurveTo(r, b, r-radius, b);
            ctx.lineTo(x+radius, b);
            ctx.quadraticCurveTo(x, b, x, b-radius);
            ctx.lineTo(x, y+radius);
            ctx.quadraticCurveTo(x, y, x+radius, y);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
        }

        function renderClip(ctx, clip) {

        }

        onPaint: {
            // get context and reset canvas
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            drawVerticalBars(ctx);

            // test for drawing roudned rectankgneoles

            var clipWidth = 100;
            var clipHeight = PJGlobalTimeline.clipHeight;
            roundRect(ctx, 0, 0, clipWidth, clipHeight, 5);

        }

        MouseArea {
            id: mousearea
            anchors.fill: parent
            scrollGestureEnabled: true

            onClicked: console.log("Clicked: " + mouse.button)

            onWheel: function(wheel) {
                // wheel telemetry // console.log(`Wheeled (${wheel.angleDelta.x}, ${wheel.angleDelta.y})`);
                PJGlobalTimeline.leftTickCutoff = Math.max(0, PJGlobalTimeline.leftTickCutoff - wheel.angleDelta.x * PJGlobalTimeline.ticksPerPixel / PJGlobalTimeline.bigTickSignificance);
                tracks.repaint();
            }
        }

        Label {
            id: goofyaahlabel
            text: "gatimala city\n good game marquez"
            font.pixelSize: 224
        }
    }
}
