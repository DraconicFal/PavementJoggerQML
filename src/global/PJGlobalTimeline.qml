pragma Singleton
import QtQuick
import "../panels/timeline"

QtObject {
    // conversion between seconds and ticks
    readonly property int ticksPerSecond: 20
    // conversion between seconds to onscreen pixels
    property double secondsPerPixel: 0.005;
    // conversion between ticks and onscreen, accounting for stretch
    property double ticksPerPixel: ticksPerSecond * secondsPerPixel * bigTickSignificance

    // minimum spacing between ticks
    readonly property double minSpacing: 10

    // spacing between ticks, in pixels
    property double spacing: 10
    // total visible ticks on screen
    property int totalTicks: 0

    // position of the scrubbing handle, in ticks
    property double scrubberTickPosition: 0
    // position of the scrubbing handle, in pixels
    property double scrubberPixelPosition: scrubberTickPosition/ticksPerPixel
    // position of the scrubbing handle, in seconds
    property double scrubberSecondPosition: scrubberTickPosition/ticksPerSecond

    // the left cutoff point of the timeline view, in ticks
    property double leftTickCutoff: 0
    // the left cutoff point of the timeline view, in pixels
    property double leftPixelCutoff: leftTickCutoff/ticksPerPixel
    // the right cutoff point of the timeline view, in pixels
    property double rightPixelCutoff: 0

    // the length of the timeline track content, in pixels
    property double trackPixelLength: 0

    // the length of the available timeline, in pixels
    property double timelinePixelLength: getTimelinePixelLength()

    // how many seconds are denoted by the distance between two big ticks
    property int bigTickSignificance: 0

    function getTimelinePixelLength() {
        return Math.max(rightPixelCutoff, scrubberPixelPosition, trackPixelLength)
    }


    //////////////////
    // TRACK VALUES //
    //////////////////

    property double clipHeight: 40


}
