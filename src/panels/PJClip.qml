import QtQuick
import PavementJogger

Item {
    id: clipAttributes
    anchors.fill: parent

    // Movement Name of this clip.
    property string movementName

    // The ID of the track this clip is on.
    property int trackID

    // Index representing this clip within its respective track
    property int trackIndex: getTrackIndex()

    // The tick at which this clip starts.
    property int startTick

    // The tick at which this clip ends.
    property int endTick

    // How many ticks this clip lasts for.
    readonly property int duration: endTick - startTick

    // The minimum amount of ticks that this clip lasts for.
    property double minDuration

    // Whether this clip is selected/highlighted.
    property bool selected: false

    function getTrackIndex(telemetry=false) {
        for (var i=0; i<PJGlobalTimeline.clips[trackID].length; i++) {
            if (Object.is(this, PJGlobalTimeline.clips[trackID][i])) {
                if (telemetry) console.log(`Clip on track ${trackID} at tick time ${startTick} found trackIndex ${i}`);
                return i
            }
        }
        if (telemetry) console.exception(`Clip on track ${trackID} at tick time ${startTick} could not determine its clipIndex!`);
        return -1;
    }

    // Constantly update trackIndex.
    readonly property var clipsArray: PJGlobalTimeline.clips
    onClipsArrayChanged: {
        trackIndex = getTrackIndex();
    }


    // Visual/interactable component.
    Rectangle {
        id: block
        clip: true

        /////////////
        // VISUALS //
        /////////////
        readonly property double cornerRadius: 4
        readonly property bool roundedCorners: width>3*cornerRadius // For setting radius to zero when the clip is too thin visually
        visible: getStartPixel()<PJGlobalTimeline.trackPixelWidth && getEndPixel()>0

        /// COLOR ///
        color: PJGlobalTimeline.hsv2rgb(75*trackID, 0.5839, 0.6314)
        border.width: getBorderWidth()
        border.color: selected ? PJGlobalTimeline.hsv2rgb(75*trackID, 0.5839, 1) : "#030303"

        // Returns the border width in pixels
        function getBorderWidth() {
            if (!roundedCorners || !selected)
                return 1;
            else
                return 2;
        }


        /// TRANSLATION ///
        x: getXPosition()
        y: getYPosition()

        // Returns the screen X position of this clip, in pixels.
        function getXPosition() {
            return Math.max(-radius, getStartPixel());
        }
        // Returns the screen Y position of this clip, in pixels.
        function getYPosition() {
            var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
            // Plus 1 to account for horizontal track separator lines
            return verticalPixelScroll + parent.trackID * PJGlobalTimeline.trackHeight + 1;
        }

        /// SCALING ///
        width: getWidth()
        height: PJGlobalTimeline.trackHeight - 2 // Minus 2 to for same reason as in getYPosition()
        radius: roundedCorners ? cornerRadius : 0

        // Returns the pixel width of this clip, bounded within the ends of the screen (in order to reduce lag)
        function getWidth() {
            var boundedStartPixel = Math.max(-cornerRadius, getStartPixel());
            var boundedEndPixel = Math.min(PJGlobalTimeline.trackPixelWidth+cornerRadius, getEndPixel());
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


        /////////////////
        // INTERACTION //
        /////////////////
        readonly property bool onlySelection: block.width <= 8*block.cornerRadius
        property bool leftDragging: false
        property bool centerDragging: false
        property bool rightDragging: false

        // Sets the cursor shape to SplitHCursor.
        function setSplitCursor() {
            var timeline = clipAttributes.parent.parent.parent.parent.parent.parent;
            timeline.scrollArea.cursorShape = Qt.SplitHCursor;
        }

        // Sets the cursor shape to ArrowCursor.
        function setArrowCursor() {
            var timeline = clipAttributes.parent.parent.parent.parent.parent.parent;
            timeline.scrollArea.cursorShape = Qt.ArrowCursor;
        }

        // Clamps a number between the given bounds.
        function clamp(x, lower, upper) {
            return Math.max(lower, Math.min(upper, x));
        }

        // Returns the width for the handles, corrected for when radius is zero.
        function getHandleWidth() {
            if (block.onlySelection)
                return 0;
            else
                return Math.min(4*block.cornerRadius, block.width/4);
        }

        // MouseArea on the left for resizing.
        MouseArea {
            id: leftHandle
            property bool hovering: false

            anchors.left: block.left
            enabled: block.visible
            hoverEnabled: true

            /// SIZING ///
            width: block.getHandleWidth()
            height: block.height

            /// CURSOR ///
            onEntered: {
                if (!(block.rightDragging || block.centerDragging)) {
                    hovering = true;
                    block.setSplitCursor();
                }
            }
            onExited: {
                if (!(block.rightDragging || block.centerDragging)) {
                    hovering = false;
                    if (!pressed)
                        block.setArrowCursor();
                }
            }

            /// RESIZING ///
            property double clickTick
            onPressed: function(mouse) {
                block.leftDragging = true;
                clickTick = PJGlobalTimeline.pixelToTick(block.x + leftHandle.x + mouse.x, false);
            }
            onReleased: {
                block.leftDragging = false;
                if (!hovering)
                    block.setArrowCursor();
            }

            onMouseXChanged: function(mouse) {
                if (pressed) {
                    var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;
                    console.log(`bts ${bigTickSignificance}`);
                    var maxTick;
                    if (clipAttributes.endTick%bigTickSignificance == 0)
                        maxTick = clipAttributes.endTick - bigTickSignificance;
                    else
                        maxTick = Math.floor(clipAttributes.endTick/bigTickSignificance)*bigTickSignificance;
                    var mouseTick = PJGlobalTimeline.pixelToTick(block.x + leftHandle.x + mouse.x, true);
                    clipAttributes.startTick = block.clamp(mouseTick, 0, maxTick);
                }
            }
        }

        // MouseArea on the right for resizing.
        MouseArea {
            id: rightHandle
            property bool hovering: false

            anchors.right: block.right
            enabled: block.visible
            hoverEnabled: true

            /// SIZING ///
            width: block.getHandleWidth()
            height: block.height

            /// CURSOR ///
            onEntered: {
                if (!(block.leftDragging || block.centerDragging)) {
                    hovering = true;
                    block.setSplitCursor();
                }
            }
            onExited: {
                if (!(block.leftDragging || block.centerDragging)) {
                    hovering = false;
                    if (!pressed)
                        block.setArrowCursor();
                }
            }

            /// RESIZING ///
            property double clickTick
            onPressed: function(mouse) {
                block.rightDragging = true;
                clickTick = PJGlobalTimeline.pixelToTick(block.x + leftHandle.x + mouse.x, false);
            }
            onReleased: {
                block.rightDragging = false;
                if (!hovering)
                    block.setArrowCursor();
            }

            onMouseXChanged: function(mouse) {
                if (pressed) {
                    var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;
                    console.log(`bts ${bigTickSignificance}`);
                    var minTick;
                    if (clipAttributes.startTick%bigTickSignificance == 0)
                        minTick = clipAttributes.startTick + bigTickSignificance;
                    else
                        minTick = Math.ceil(clipAttributes.startTick/bigTickSignificance)*bigTickSignificance;
                    var mouseTick = PJGlobalTimeline.pixelToTick(block.x + rightHandle.x + mouse.x, true);
                    clipAttributes.endTick = block.clamp(mouseTick, minTick, Infinity);
                }
            }
        }

        // MouseArea used for selection and translation.
        MouseArea {
            id: centerArea
            anchors.centerIn: block
            enabled: block.visible

            /// SIZING ///
            width: block.width - 2*block.getHandleWidth()
            height: block.height

            /// SELECTION ///
            property double clickTick
            property bool timelinePressed: PJGlobalTimeline.timelinePressed
            onTimelinePressedChanged: {
                if (!pressed && !PJGlobalKeyboard.shiftPressed && !PJGlobalKeyboard.ctrlPressed && timelinePressed)
                    clipAttributes.selected = false;
            }
            onPressed: function(mouse) {
                block.centerDragging = true;
                PJGlobalTimeline.timelinePressed = true;
                clickTick = PJGlobalTimeline.pixelToTick(block.x + centerArea.x + mouse.x, false);
                if (PJGlobalKeyboard.ctrlPressed && !PJGlobalKeyboard.shiftPressed)
                    clipAttributes.selected = !clipAttributes.selected
                else
                    clipAttributes.selected = true;
            }
            onReleased: {
                block.centerDragging = false;
                PJGlobalTimeline.timelinePressed = false;
            }
        }

    }

}
