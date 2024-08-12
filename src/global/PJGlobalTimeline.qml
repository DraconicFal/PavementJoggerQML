pragma Singleton
import QtQuick
import QtQml.XmlListModel
import "../panels"
import "../panels/timeline"

QtObject {

    //////////////////
    // TRACK VALUES //
    //////////////////

    // Conversion between seconds and ticks.
    readonly property int ticksPerSecond: 20
    // Initial secondsPerPixel value.
    readonly property double initSecondsPerPixel: 0.005
    // Conversion between seconds to onscreen pixels.
    property double secondsPerPixel: 0.005
    // Conversion between ticks and onscreen, accounting for stretch.
    property double ticksPerPixel: ticksPerSecond * secondsPerPixel * bigTickSignificance

    // Minimum spacing between ticks.
    readonly property double minSpacing: 10

    // Spacing between ticks, in pixels.
    property double spacing: 10
    // Total visible ticks on screen.
    property int totalTicks: 0

    // Position of the scrubbing handle, in ticks.
    property double scrubberTickPosition: 0
    // Position of the scrubbing handle, in pixels.
    property double scrubberPixelPosition: scrubberTickPosition/ticksPerPixel
    // Position of the scrubbing handle, in seconds.
    property double scrubberSecondPosition: scrubberTickPosition/ticksPerSecond

    // The left cutoff point of the timeline view, in ticks.
    property double leftTickCutoff: 0
    // The left cutoff point of the timeline view, in pixels.
    property double leftPixelCutoff: leftTickCutoff/ticksPerPixel * bigTickSignificance
    // The right cutoff point of the timeline view, in pixels.
    property double rightPixelCutoff: 0

    // The vertical positioning of the track alignment lines, in pixels.
    property double verticalPixelScroll: 0

    // The initial height of each track, in pixels.
    property double initTrackHeight: 60
    // The height of each track, in pixels.
    property double trackHeight: 60
    // The length of the timeline track content, in pixels.
    property double trackPixelWidth: 0
    // The height of the timeline track content, in pixels.
    property double trackPixelHeight: 0

    // The length of the available timeline, in pixels.
    property double timelinePixelLength: getTimelinePixelLength()

    // How many seconds are denoted by the distance between two big ticks.
    property int bigTickSignificance: 0

    // Return the hh:mm:ss.ms string representation of a tick position within the timeline.
    function getTimestampText(position) {
        var ticksPerSecond = PJGlobalTimeline.ticksPerSecond;

        var millis = String(1000 * (position % ticksPerSecond) / ticksPerSecond).padStart(3, '0');
        var seconds = String(Math.floor(position / ticksPerSecond) % 60).padStart(2, '0');
        var minutes = String(Math.floor(position / ticksPerSecond / 60) % 60).padStart(2, '0');
        var hours = String(Math.floor(position / ticksPerSecond / 3600)).padStart(2, '0');
        return hours + ":" + minutes + ":" + seconds + "." + millis;
    }

    // Convert a pixel X position within the track to the corresponding tick
    function pixelToTick(pixelX, round) {
        var projectedPosition = leftTickCutoff + pixelX * (secondsPerPixel * ticksPerSecond);
        if (round) {
            projectedPosition = Math.round(projectedPosition / bigTickSignificance) * bigTickSignificance;
        }
        return projectedPosition;
    }

    // TODO: determine effective timeline length?
    function getTimelinePixelLength() {
        return Math.max(rightPixelCutoff, scrubberPixelPosition, trackPixelWidth)
    }

    // Attempt to the tracks horizontally by the given amount in pixels.
    function scrollHorizontally(pixels) {
        leftTickCutoff = Math.max(0, leftTickCutoff - pixels * ticksPerPixel / bigTickSignificance);
    }

    // Attempt to the tracks vertically by the given amount in pixels.
    function scrollVertically(pixels) {
        verticalPixelScroll = Math.min(0, verticalPixelScroll + pixels);
    }


    /////////////////
    // CLIP VALUES //
    /////////////////

    // Clips is a list of PJClip's.
    property list<PJClip> clips: ({})


    //////////////////////
    // HELPER FUNCTIONS //
    //////////////////////
    function hsv2rgb(h,s,v) {
        let f = function(n,k=(n+h/60)%6) {
            var ret = v - v*s*Math.max( Math.min(k,4-k,1), 0);
            ret = ("00" + (Math.round(ret*255)).toString(16)).substr(-2);
            return ret;
        }
        return `#${f(5)}${f(3)}${f(1)}`;
    }

}
