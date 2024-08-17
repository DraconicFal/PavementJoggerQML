import QtQuick
import PavementJogger

Rectangle {
    id: block
    clip: true
    visible: false
    radius: 4
    opacity: 1

    Component.onCompleted: {
        PJGlobalPalette.shadowItem = block;
    }

    property int trackID
    property int startTick
    property int endTick



    /////////////
    // VISUALS //
    /////////////
    color: PJGlobalTimeline.hsv2rgb(75*trackID, 0.6, 0.5314)



    /// COMMAND FUNCTIONS ///

    function showAt(trackID, startTick, endTick) {
        // Initialize
        block.trackID = trackID;
        block.startTick = startTick;
        block.endTick = endTick;

        // Visuals
        block.visible = true;
        block.x = block.getXPosition();
        block.y = block.getYPosition();
        block.width = block.getWidth();
        block.height = PJGlobalTimeline.trackHeight - 2;
    }

    function hide() {
        block.visible = false;
    }



    /// SCALING FUNCTIONS ///

    // Returns the screen X position of this clip, in pixels.
    function getXPosition() {
        return Math.max(-radius, getStartPixel());
    }

    // Returns the screen Y position of this clip, in pixels.
    function getYPosition() {
        var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
        return verticalPixelScroll + block.trackID * PJGlobalTimeline.trackHeight + 1;
    }

    // Returns the pixel width of this clip, bounded within the ends of the screen (in order to reduce lag).
    function getWidth() {
        var boundedStartPixel = Math.max(-block.radius, getStartPixel());
        var boundedEndPixel = Math.min(PJGlobalTimeline.trackPixelWidth+block.radius, getEndPixel());
        return boundedEndPixel - boundedStartPixel;
    }

    // Returns the position of this clip's left endpoint, in pixels.
    function getStartPixel() {
        return PJGlobalTimeline.bigTickSignificance * block.startTick/PJGlobalTimeline.ticksPerPixel - PJGlobalTimeline.leftPixelCutoff;
    }

    // Returns the position of this clip's right endpoint, in pixels.
    function getEndPixel() {
        return PJGlobalTimeline.bigTickSignificance * block.endTick/PJGlobalTimeline.ticksPerPixel - PJGlobalTimeline.leftPixelCutoff;
    }

}
