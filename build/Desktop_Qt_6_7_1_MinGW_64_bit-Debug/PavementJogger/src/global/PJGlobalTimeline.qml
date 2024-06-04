pragma Singleton
import QtQuick

QtObject {
    // conversion between seconds and ticks
    readonly property int ticksPerSecond: 20
    // minimum spacing between ticks
    readonly property double minSpacing: 10

    // position of the scrubbing handle, in ticks
    property int scrubberPosition: 0

    // the left cutoff point of the timeline view, in ticks
    property double leftCutoff: 0
    // the horizontal width of the timeline view, in ticks
    property double secondsPerPixel: 0.005;
    // how many seconds are denoted by the distance between two big ticks
    property int bigTickSignificance: 0


}
