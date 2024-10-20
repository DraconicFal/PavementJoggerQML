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

            var names = PJGlobalTimeline.tracks;

            // render horizontal lines
            var width = 1;
            var fontSize = 12.5;
            var sideMargin = fontSize;
            ctx.font = `${fontSize}px sans-serif`;

            var startPixel = verticalPixelScroll % trackHeight - trackHeight;
            var startIndex = Math.ceil(verticalPixelScroll / trackHeight)+1;
            var n = names.length+1;
            for (var i = 0; i < n; i++) {
                // Render text
                var nameIndex = i-startIndex;
                var textWidth = ctx.measureText(`${names[nameIndex]}`).width;
                if (0<=nameIndex && nameIndex<names.length) {
                    ctx.fillStyle = "#ffffff";
                    ctx.fillText(`${names[nameIndex]}`, sideMargin, Math.round(startPixel + 4/3*fontSize));
                }
                // Render color bar
                var colorBarWidth = 5;
                ctx.fillStyle = PJGlobalTimeline.hsv2rgb(75*(i-1), 0.7, 0.7314);
                ctx.fillRect(0, startPixel, colorBarWidth, trackHeight);
                // Render lines
                ctx.fillStyle = "#090909";
                ctx.fillRect(colorBarWidth-1, startPixel, width, trackHeight);
                ctx.fillRect(0, startPixel-width/2, canvas.width, width);
                ctx.fillRect(0, startPixel+2*fontSize-width/2, canvas.width, width);
                ctx.fillRect(textWidth+2*sideMargin-width/2, startPixel, width, 2*fontSize);
                startPixel += trackHeight;
            }
            ctx.fillStyle = "#090909";
            ctx.fillRect(0, startPixel-width/2, canvas.width, width);
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
