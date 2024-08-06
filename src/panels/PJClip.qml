import QtQuick
import PavementJogger

Item {
    id: clip
    anchors.fill: parent

    // Expose the internal properties to be set from outside
    required property int init_clipID
    required property int init_trackID
    required property int init_startTick
    required property int init_endTick
    required property double init_minDuration

    // Aliases for private/internal properties.
    readonly property alias clipID: internal.clipID
    readonly property alias trackID: internal.trackID
    readonly property alias startTick: internal.startTick
    readonly property alias endTick: internal.endTick
    readonly property alias duration: internal.duration

    // Set the start tick of this clip with error handling.
    function setStartTick(tick) {
        if (tick >= endTick) {
            console.warn(`Tried to set clip ${clipID}'s startTick to ${tick} >= endTick = ${endTick}!`);
            return;
        }
        if (endTick-tick < internal.minDuration) {
            console.warn(`Tried to set clip ${clipID}'s startTick to ${tick}, but resulting duration = ${endTick-tick} < minDuration = ${internal.minDuration}!`);
            return;
        }
        internal.startTick = tick;
    }

    // Set the end tick of this clip with error handling.
    function setEndTick(tick) {
        if (tick <= startTick) {
            console.warn(`Tried to set clip ${clipID}'s endTick to ${tick} <= startTick = ${startTick}!`);
            return;
        }
        if (tick-startTick < internal.minDuration) {
            console.warn(`Tried to set clip ${clipID}'s endTick to ${tick}, but resulting duration = ${tick-startTick} < minDuration = ${internal.minDuration}!`);
            return;
        }
        internal.endTick = tick;
    }

    // Save init variables to internal variables
    Component.onCompleted: {
        if (init_minDuration <= 0) {
            console.exception(`Clip ${init_clipID}'s minDuration = ${init_minDuration} <= 0!`);
            parent.destroy();
            Qt.exit(-1);
        }
        if (init_startTick >= init_endTick) {
            console.exception(`Clip ${init_clipID}'s startTick = ${init_startTick} >= endTick = ${init_endTick}!`);
            parent.destroy();
            Qt.exit(-1);
        }
        if (init_endTick-init_startTick < init_minDuration) {
            console.exception(`Clip ${init_clipID}'s duration = ${init_endTick-init_startTick} < minDuration = ${init_minDuration}!`);
            parent.destroy();
            Qt.exit(-1);
        }
        // TODO: Add condition for intersections with other clips
        internal.clipID = init_clipID;
        internal.trackID = init_trackID;
        internal.startTick = init_startTick;
        internal.endTick = init_endTick;
        internal.minDuration = init_minDuration;
    }

    // Private value container.
    QtObject {
        id: internal

        // Unique ID of this clip.
        property int clipID: parent.init_clipID

        // The ID of the track this clip is on.
        property int trackID: parent.init_trackID

        // The tick at which this clip starts.
        property int startTick: parent.init_startTick

        // The tick at which this clip ends.
        property int endTick: parent.init_endTick

        // How many ticks this clip lasts for.
        readonly property int duration: internal.endTick - internal.startTick

        // The minimum amount of ticks that this clip lasts for.
        property double minDuration: parent.init_minDuration
    }


    Rectangle {
        id: visual
        visible: getStartPixel()<PJGlobalTimeline.trackPixelWidth && getEndPixel()>0
        color: "gray"
        border.width: 2
        border.color: "#212229"

        x: Math.max(-radius, getStartPixel())
        y: parent.trackID * PJGlobalTimeline.clipHeight

        onXChanged: {
            console.log(`Visible ${visible} | Start pixel ${getStartPixel()} | End pixel ${getEndPixel()}`);
        }

        width: getWidth()
        height: PJGlobalTimeline.clipHeight
        radius: 5

        function getWidth() {
            var boundedStartPixel = Math.max(-radius, getStartPixel());
            var boundedEndPixel = Math.min(PJGlobalTimeline.trackPixelWidth+radius, getEndPixel());
            return boundedEndPixel - boundedStartPixel;
        }

        // Returns the position of this clip's left endpoint, in pixels.
        function getStartPixel() {
            return PJGlobalTimeline.bigTickSignificance * parent.startTick/PJGlobalTimeline.ticksPerPixel - PJGlobalTimeline.leftPixelCutoff;
        }

        // Returns the position of this clip's right endpoint, in pixels.
        function getEndPixel() {
            return PJGlobalTimeline.bigTickSignificance * parent.endTick/PJGlobalTimeline.ticksPerPixel - PJGlobalTimeline.leftPixelCutoff;
        }

    }

}
