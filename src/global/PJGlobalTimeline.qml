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

    // position of the scrubbing handle, in ticks
    property double scrubberTickPosition: 0
    // position of the scrubbing handle, in pixels
    property double scrubberPixelPosition: scrubberTickPosition/ticksPerPixel
    // position of the scrubbing handle, in seconds
    property double scrubberSecondPosition: scrubberTickPosition/ticksPerSecond

    // the left cutoff point of the timeline view, in ticks
    property double leftCutoff: 0
    // how many seconds are denoted by the distance between two big ticks
    property int bigTickSignificance: 0

}
