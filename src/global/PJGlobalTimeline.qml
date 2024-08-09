pragma Singleton
import QtQuick
import "../panels"
import "../panels/timeline"

QtObject {

    //////////////////
    // TRACK VALUES //
    //////////////////

    // Conversion between seconds and ticks.
    readonly property int ticksPerSecond: 20
    // Conversion between seconds to onscreen pixels.
    property double secondsPerPixel: 0.005;
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

    // The height of each track, in pixels.
    property double trackHeight: 60
    // The length of the timeline track content, in pixels.
    property double trackPixelWidth: 0
    // The height of the timeline track content, in pixels.
    property double trackPixelHeight: 0

    // The length of the available timeline, in pixels.
    property double timelinePixelLength: getTimelinePixelLength()
    function getTimelinePixelLength() {
        return Math.max(rightPixelCutoff, scrubberPixelPosition, trackPixelWidth)
    }

    // How many seconds are denoted by the distance between two big ticks.
    property int bigTickSignificance: 0



    /////////////////
    // CLIP VALUES //
    /////////////////

    property var clips: ({})

}
