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

        onPaint: {
            // Get context and reset canvas
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Render tracks background
            drawVerticalBars(ctx);
            PJGlobalTimeline.trackPixelWidth = tracks.width;
            PJGlobalTimeline.trackPixelHeight = tracks.height;
        }

        MouseArea {
            id: mousearea
            anchors.fill: parent
            scrollGestureEnabled: true

            onWheel: function(wheel) {
                // wheel telemetry // console.log(`Wheeled (${wheel.angleDelta.x}, ${wheel.angleDelta.y})`);
                var deltaX = wheel.angleDelta.x;
                if (mousearea.shiftPressed) deltaX += wheel.angleDelta.y;
                PJGlobalTimeline.leftTickCutoff = Math.max(0, PJGlobalTimeline.leftTickCutoff - deltaX * PJGlobalTimeline.ticksPerPixel / PJGlobalTimeline.bigTickSignificance);
                tracks.repaint();
            }

            // Handle side scroll via shift+scroll
            // TODO: fix because it gets disabled when clicking any other mousearea
            property bool shiftPressed: false
            // focus: true
            // Keys.onPressed: (event)=> {
            //     if (event.key === Qt.Key_Shift) {
            //         mousearea.shiftPressed = true;
            //     }
            // }
            // Keys.onReleased: (event)=> {
            //     if (event.key === Qt.Key_Shift) {
            //         mousearea.shiftPressed = false;
            //     }
            // }
        }


        // TEST CLIP --- REMOVE LATER
        PJClip {
            id: testClip

            // Initialize the internal properties
            init_clipID: 0
            init_trackID: 0
            init_startTick: 80
            init_endTick: 90
            init_minDuration: 5.0

            MouseArea {
                anchors.fill: parent
                focus: true
                Keys.onPressed: (event)=> {
                    if (event.key === Qt.Key_Left) {
                        parent.setStartTick(parent.startTick-10);
                        parent.setEndTick(parent.endTick-10);
                        console.log("pressing left");
                    }
                    if (event.key === Qt.Key_Right) {
                        parent.setEndTick(parent.endTick+10);
                        parent.setStartTick(parent.startTick+10);
                        console.log("pressing right");
                    }
                }
            }
        }

    }

}
