import QtQuick
import PavementJogger

Item {
    id: trackLabels

    signal repaintTimeline()
    function repaint() {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        function renderLabels(ctx) {
            // get the start position and spacing
            var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
            var trackHeight = PJGlobalTimeline.trackHeight;

            var names = ["Track A", "Track B", "Track C", "Track D", "Track E", "The FitnessGram PACER Test is a multi-stage aerobic capacity test, that progressively gets more difficult as it continues", "aaron he real?!??!!//1"];

            // render horizontal lines
            var width = 1;
            var fontSize = 12.5
            ctx.font = `${fontSize}px sans-serif`;

            var startPixel = verticalPixelScroll % trackHeight - trackHeight;
            var startIndex = Math.ceil(verticalPixelScroll / trackHeight)+1;
            var n = Math.floor(canvas.height / trackHeight) + 2;
            for (var i = 0; i < n; i++) {
                var yPixel = startPixel + i*trackHeight;
                ctx.fillStyle = "#090909";
                ctx.fillRect(0, yPixel-width/2, canvas.width, width);
                var nameIndex = i-startIndex;
                if (0<=nameIndex && nameIndex<names.length) {
                    ctx.fillStyle = "#ffffff";
                    ctx.fillText(`${names[nameIndex]}`, fontSize/2, Math.round(yPixel + (trackHeight+fontSize)/2));
                }
            }
        }

        onPaint: {
            // Get context and reset canvas
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Render labels
            renderLabels(ctx);

        }
    }

}
