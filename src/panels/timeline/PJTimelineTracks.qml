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
            var n = Math.floor(canvas.height / trackHeight) + 2;
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

        // MouseArea {
        //     id: mousearea
        //     anchors.fill: parent
        //     scrollGestureEnabled: true

        //     onWheel: function(wheel) {
        //         // wheel telemetry // console.log(`Wheeled (${wheel.angleDelta.x}, ${wheel.angleDelta.y})`);
        //         var deltaX = wheel.angleDelta.x;
        //         var kY = 0.1
        //         var deltaY = wheel.angleDelta.y * kY;
        //         if (mousearea.shiftPressed) {
        //             deltaX += wheel.angleDelta.y;
        //             deltaY = 0;
        //         }
        //         PJGlobalTimeline.scrollHorizontally(deltaX);
        //         PJGlobalTimeline.scrollVertically(deltaY);
        //         tracks.repaintTimeline();
        //     }

        //     // Handle side scroll via shift+scroll
        //     // TODO: fix because it gets disabled when clicking any other mousearea
        //     property bool shiftPressed: false
        //     // focus: true
        //     // Keys.onPressed: (event)=> {
        //     //     if (event.key === Qt.Key_Shift) {
        //     //         mousearea.shiftPressed = true;
        //     //     }
        //     // }
        //     // Keys.onReleased: (event)=> {
        //     //     if (event.key === Qt.Key_Shift) {
        //     //         mousearea.shiftPressed = false;
        //     //     }
        //     // }
        // }


        // TEST CLIP --- REMOVE LATER
        PJClip {
            id: testClip1

            // Initialize the internal properties
            init_clipID: 0
            init_trackID: 0
            init_startTick: 20
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

        PJClip {
            id: testClip2

            init_clipID: 1
            init_trackID: 1
            init_startTick: 40
            init_endTick: 120
            init_minDuration: 5.0
        }

        PJClip {
            id: testClip3

            init_clipID: 2
            init_trackID: 2
            init_startTick: 0
            init_endTick: 200
            init_minDuration: 5.0
        }

    }

}
