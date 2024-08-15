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
    readonly property double initSecondsPerPixel: 0.04
    // Conversion between seconds to onscreen pixels.
    property double secondsPerPixel: 0.04
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

    // Clamps a number between the given bounds.
    function clamp(x, lower, upper) {
        return Math.max(lower, Math.min(upper, x));
    }

    // Attempt to the tracks horizontally by the given amount in pixels.
    function scrollHorizontally(pixels) {
        leftTickCutoff = Math.max(0, leftTickCutoff - pixels * ticksPerPixel / bigTickSignificance);
    }

    // Attempt to the tracks vertically by the given amount in pixels.
    function scrollVertically(pixels) {
        var minScrollY = Math.min(0, trackPixelHeight - tracks.length*trackHeight);
        verticalPixelScroll = clamp(verticalPixelScroll + pixels, minScrollY, 0);
    }


    /////////////////
    // CLIP VALUES //
    /////////////////

    // For deciding clip selection.
    property bool timelinePressed: false
    onTimelinePressedChanged: {
        if (!timelinePressed) {
            visualSelectionUpdateNeeded = false;
        }
    }

    // Whether or not a selection is being dragged on the canvas.
    property bool selectionDragging: false

    // Tracks is a list of strings, representing the name of each track.
    property var tracks: []

    // Clips is a 2D list, where each sublist represents a track and contains PJClip's.
    property var clips: []

    // Same shape array as Clips, contains booleans for whether or not the corresponding clip is selected.
    property var selection: []
    onClipsChanged: {
        selection = [];
        for (var r=0; r<clips.length; r++) {
            selection.push([]);
            for (var c=0; c<clips[r].length; c++) {
                selection[r].push(false);
            }
        }
    }

    // Boundaries for selection.
    property int minSelectionTick: 0
    property int maxSelectionTick: 0
    property int minSelectionTrack: 0
    property int maxSelectionTrack: 0
    property bool visualSelectionUpdateNeeded: false

    function updateSelectionBounds(telemetry=false) {
        // Determine boundaries
        var proc_minSelectionTick = null;
        var proc_maxSelectionTick = null;
        var proc_minSelectionTrack = null;
        var proc_maxSelectionTrack = null;
        for (var track=0; track<clips.length; track++) {
            for (var index=0; index<clips[track].length; index++) {
                if (selection[track][index]) {
                    var startTick = clips[track][index].startTick;
                    var endTick = clips[track][index].endTick;
                    proc_minSelectionTick = proc_minSelectionTick==null ? startTick : Math.min(proc_minSelectionTick, startTick);
                    proc_maxSelectionTick = proc_maxSelectionTick==null ? endTick : Math.max(proc_maxSelectionTick, endTick);
                    proc_minSelectionTrack = proc_minSelectionTrack==null ? track : Math.min(proc_minSelectionTrack, track);
                    proc_maxSelectionTrack = proc_maxSelectionTrack==null ? track : Math.max(proc_maxSelectionTrack, track);
                }
            }
        }
        minSelectionTick = proc_minSelectionTick==null ? -1 : proc_minSelectionTick;
        maxSelectionTick = proc_maxSelectionTick==null ? -1 : proc_maxSelectionTick;
        minSelectionTrack = proc_minSelectionTrack==null ? -1 : proc_minSelectionTrack;
        maxSelectionTrack = proc_maxSelectionTrack==null ? -1 : proc_maxSelectionTrack;

        if (telemetry) {
            console.log("\nSelection bounds");
            console.log(`-------- minSelectionTick ${minSelectionTick}`);
            console.log(`-------- maxSelectionTick ${maxSelectionTick}`);
            console.log(`-------- minSelectionTrack ${minSelectionTrack}`);
            console.log(`-------- maxSelectionTrack ${maxSelectionTrack}`);
        }
    }

    // Select clips within selection bounds.
    function performMultiSelect() {
        if (minSelectionTick==-1 || maxSelectionTick==-1 || minSelectionTrack==-1 || maxSelectionTrack==-1) return;
        if (!PJGlobalKeyboard.shiftPressed) return;
        for (var track=minSelectionTrack; track<=maxSelectionTrack; track++) {
            for (var index=0; index<clips[track].length; index++) {
                var startTick = clips[track][index].startTick;
                var endTick = clips[track][index].endTick;
                if (startTick < maxSelectionTick && endTick > minSelectionTick) {
                    selection[track][index] = true;
                }
            }
        }
        visualSelectionUpdateNeeded = true;
    }


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
