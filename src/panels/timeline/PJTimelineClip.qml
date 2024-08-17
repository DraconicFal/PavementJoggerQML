import QtQuick
import PavementJogger

Item {
    id: attributes
    anchors.fill: parent

    property alias block: block

    ////////////////
    // ATTRIBUTES //
    ////////////////

    // Constantly update trackIndex.
    readonly property var clips: PJGlobalTimeline.clips
    onClipsChanged: {
        trackIndex = getTrackIndex();
    }

    // Returns whether or not global clips array exists.
    function getClipsExists() {
        return typeof(clips) !== "undefined" && clips.length > 0;
    }

    // Movement Name of this clip.
    property string movementName

    // The ID of the track this clip is on.
    property int trackID

    // Index representing this clip within its respective track
    property int trackIndex: getTrackIndex()
    function getTrackIndex(telemetry=false) {
        if (!getClipsExists()) return -1;
        for (var i=0; i<clips[trackID].length; i++) {
            if (Object.is(this, clips[trackID][i])) {
                if (telemetry) console.log(`Clip on track ${trackID} at tick time ${startTick} found trackIndex ${i}`);
                return i
            }
        }
        if (telemetry) console.exception(`Clip on track ${trackID} at tick time ${startTick} could not determine its clipIndex!`);
        return -1;
    }

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



    ///////////////////////////////////
    // VISUALS/INTERACTION COMPONENT //
    ///////////////////////////////////
    Rectangle {
        id: block
        clip: true

        /////////////
        // VISUALS //
        /////////////
        readonly property double cornerRadius: 4
        readonly property bool roundedCorners: width>3*cornerRadius // For setting radius to zero when the clip is too thin visually
        visible: getStartPixel()<PJGlobalTimeline.trackPixelWidth && getEndPixel()>0


        ////////////TEMPORARY REMOVE LATER//////////////
        Text {
            anchors.centerIn: parent
            text: `${trackIndex}`
            color: "white"
            font.pixelSize: 20
        }



        /// LABEL ///
        Rectangle {
            id: label
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            color: PJGlobalTimeline.hsv2rgb(75*trackID, 0.6, 0.615)
            height: 1.5*text.font.pixelSize
            radius: parent.radius

            Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - text.font.pixelSize

                property double leftMargin: 5
                x: leftMargin

                font.pixelSize: 11
                color: "white"
                text: movementName
                elide: Text.ElideRight
            }
        }



        /// FILL & BORDER ///
        color: PJGlobalTimeline.hsv2rgb(75*trackID, 0.6, 0.5314)
        Rectangle {
            id: border
            anchors.fill: parent
            color: "transparent"

            radius: parent.radius
            border.width: parent.getBorderWidth()
            border.color: selected ? PJGlobalTimeline.hsv2rgb(75*trackID, 0.5839, 1) : "#030303"
        }

        // Returns the border width in pixels
        function getBorderWidth() {
            if (!roundedCorners || !selected)
                return 1.125;
            else
                return 2;
        }



        /// TRANSLATION ///
        x: getXPosition()
        y: getYPosition()

        // Movement Animation
        property bool behaviorEnabled: false
        Behavior on x {
            enabled: block.behaviorEnabled
            PropertyAnimation {
                id: animationX
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
        onXChanged: if (block.behaviorEnabled && x===getXPosition()) block.behaviorEnabled = false;

        // Returns the screen X position of this clip, in pixels.
        function getXPosition() {
            return Math.max(-radius, getStartPixel());
        }
        // Returns the screen Y position of this clip, in pixels.
        function getYPosition() {
            var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
            return verticalPixelScroll + parent.trackID * PJGlobalTimeline.trackHeight + 1; // Plus 1 to account for horizontal track separator lines.
        }



        /// SCALING ///
        width: getWidth()
        height: PJGlobalTimeline.trackHeight - 2 // Minus 2 to account for track separator lines.
        radius: roundedCorners ? cornerRadius : 0

        // Returns the pixel width of this clip, bounded within the ends of the screen (in order to reduce lag).
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
            var timeline = attributes.parent.parent.parent.parent.parent.parent;
            timeline.scrollArea.cursorShape = Qt.SplitHCursor;
        }

        // Sets the cursor shape to ArrowCursor.
        function setArrowCursor() {
            var timeline = attributes.parent.parent.parent.parent.parent.parent;
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

        // Returns an array of the same shape as the global clips array, with
        // each clip element being a tuple containing startTick and endTick.
        function getClipPositions() {
            var clipPositions = [];
            for (var track=0; track<clips.length; track++) {
                clipPositions.push([]);
                for (var index=0; index<clips[track].length; index++) {
                    var clip = clips[track][index];
                    clipPositions[track].push([clip.startTick, clip.endTick]);
                }
            }
            return clipPositions;
        }

        // Displaces the clip selection by the given deltaTicks
        function displaceSelection(clipPositions, deltaStartTick, deltaEndTick) {
            for (var track=0; track<clips.length; track++) {
                for (var index=0; index<clips[track].length; index++) {
                    if (PJGlobalTimeline.selection[track][index]) {
                        clips[track][index].startTick = clipPositions[track][index][0] + deltaStartTick;
                        clips[track][index].endTick = clipPositions[track][index][1] + deltaEndTick;
                    }
                }
            }
        }

        // Attempts to select this clip.
        function attemptSelection() {
            // Selection with modifiers
            if (PJGlobalKeyboard.ctrlPressed && !PJGlobalKeyboard.shiftPressed) {
                PJGlobalTimeline.selection[trackID][trackIndex] = !PJGlobalTimeline.selection[trackID][trackIndex]
            } else {
                if (!PJGlobalTimeline.selection[trackID][trackIndex]) {
                    PJGlobalTimeline.selection[trackID][trackIndex] = true;
                    PJGlobalTimeline.timelinePressed = true;
                }
            }

            // Multi-select condition
            if (PJGlobalKeyboard.shiftPressed &&
                    PJGlobalTimeline.timelinePressed) {
                PJGlobalTimeline.updateSelectionBounds(); // only do Multiple Select if this clip was just selected
                PJGlobalTimeline.performMultiSelect();
            }

            selected = PJGlobalTimeline.selection[trackID][trackIndex];
        }

        // Sets global pressed to false.
        function unpress() {
            PJGlobalTimeline.timelinePressed = false;
            PJGlobalTimeline.selectionDragging = false;
        }

        // Deselection sensing for this clip.
        property bool timelinePressed: PJGlobalTimeline.timelinePressed
        onTimelinePressedChanged: {
            if (!(leftHandle.pressed || centerArea.pressed || rightHandle.pressed) &&
                    !PJGlobalKeyboard.shiftPressed &&
                    !PJGlobalKeyboard.ctrlPressed &&
                    !PJGlobalTimeline.selectionDragging &&
                    timelinePressed) {
                PJGlobalTimeline.selection[trackID][trackIndex] = false;
            }
            selected = PJGlobalTimeline.selection[trackID][trackIndex];
        }

        // Attempt to scroll horizontally while mouse is dragging.
        function attemptScroll(mouseX, width) {
            var projectedLeftCutoff = PJGlobalTimeline.leftTickCutoff;
            var scrollMargin = 100;
            var scrolled = false;
            if (mouseX < scrollMargin) {
                projectedLeftCutoff += bigTickSignificance * (mouseX-scrollMargin) / 100;
                scrolled = true;
            }
            if (mouseX > width - scrollMargin) {
                projectedLeftCutoff += bigTickSignificance *(mouseX-(width - scrollMargin)) / 100;
                scrolled = true;
            }
            projectedLeftCutoff = Math.max(0, projectedLeftCutoff);
            if (scrolled) {
                PJGlobalTimeline.leftTickCutoff = projectedLeftCutoff;
            }
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
                if (!(block.rightDragging || block.centerDragging || PJGlobalTimeline.timelinePressed || PJGlobalPalette.paletteDragging)) {
                    hovering = true;
                    block.setSplitCursor();
                }
            }
            onPositionChanged: {
                if (hovering && !(PJGlobalTimeline.timelinePressed || PJGlobalPalette.paletteDragging)) {
                    block.setSplitCursor();
                }
            }
            onExited: {
                if (!(block.rightDragging || block.centerDragging || PJGlobalTimeline.timelinePressed || PJGlobalPalette.paletteDragging)) {
                    hovering = false;
                    if (!pressed)
                        block.setArrowCursor();
                }
            }

            /// RESIZING ///
            property double clickTick
            property var clipPositions

            // Drag preparation
            onPressed: function(mouse) {
                clickTick = PJGlobalTimeline.pixelToTick(block.x + leftHandle.x + mouse.x, true);
                clipPositions = block.getClipPositions();
                block.attemptSelection();
            }
            onReleased: {
                block.leftDragging = false;
                if (!hovering)
                    block.setArrowCursor();
                block.unpress();
            }

            // Dragging
            onMouseXChanged: function(mouse) {
                var mouseX = block.x + leftHandle.x + mouse.x;
                var mouseTick = PJGlobalTimeline.pixelToTick(mouseX, true);
                if (pressed && (mouseTick !== clickTick || block.leftDragging)) {
                    PJGlobalTimeline.selectionDragging = true;
                    block.leftDragging = true;
                    var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;

                    // Get bounded deltaTick
                    var deltaTick = mouseTick - clickTick - clipPositions[trackID][trackIndex][0]%PJGlobalTimeline.bigTickSignificance;
                    for (var track=0; track<clipPositions.length; track++) {
                        for (var index=0; index<clipPositions[track].length; index++) {
                            if (PJGlobalTimeline.selection[track][index]) {
                                var startTick = clipPositions[track][index][0];
                                var endTick = clipPositions[track][index][1];
                                var minDuration = clips[track][index].minDuration;
                                // Find minDeltaTick
                                var minDeltaTick;
                                if (index==0) {
                                    minDeltaTick = -startTick;
                                } else {
                                    minDeltaTick = clips[track][index-1].endTick - startTick;
                                }
                                // Find maxDeltaTick
                                var maxDeltaTick;
                                if (endTick%bigTickSignificance == 0)
                                    maxDeltaTick = Math.min(endTick - bigTickSignificance, endTick - minDuration) - startTick;
                                else
                                    maxDeltaTick = Math.min(Math.floor(endTick/bigTickSignificance)*bigTickSignificance, endTick - minDuration) - startTick;
                                // Constrain deltaTick
                                deltaTick = block.clamp(deltaTick, minDeltaTick, maxDeltaTick);
                            }
                        }
                    }

                    // Displace clip startTicks in selection by deltaTick
                    block.displaceSelection(clipPositions, deltaTick, 0);

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
                if (!(block.leftDragging || block.centerDragging || PJGlobalTimeline.timelinePressed || PJGlobalPalette.paletteDragging)) {
                    hovering = true;
                    block.setSplitCursor();
                }
            }
            onPositionChanged: {
                if (hovering) {
                    block.setSplitCursor();
                }
            }
            onExited: {
                if (!(block.leftDragging || block.centerDragging || PJGlobalTimeline.timelinePressed || PJGlobalPalette.paletteDragging)) {
                    hovering = false;
                    if (!pressed)
                        block.setArrowCursor();
                }
            }

            /// RESIZING ///
            property double clickTick
            property var clipPositions

            // Drag preparation
            onPressed: function(mouse) {
                clickTick = PJGlobalTimeline.pixelToTick(block.x + rightHandle.x + mouse.x, true);
                clipPositions = block.getClipPositions();
                block.attemptSelection();
            }
            onReleased: {
                block.rightDragging = false;
                if (!hovering)
                    block.setArrowCursor();
                block.unpress();
            }

            // Dragging
            onMouseXChanged: function(mouse) {
                var mouseTick = PJGlobalTimeline.pixelToTick(block.x + rightHandle.x + mouse.x, true);
                if (pressed && (mouseTick !== clickTick || block.rightDragging)) {
                    PJGlobalTimeline.selectionDragging = true;
                    block.rightDragging = true;
                    var bigTickSignificance = PJGlobalTimeline.bigTickSignificance;

                    // Get bounded deltaTick
                    var deltaTick = mouseTick - clickTick - clipPositions[trackID][trackIndex][1]%PJGlobalTimeline.bigTickSignificance;
                    for (var track=0; track<clipPositions.length; track++) {
                        for (var index=0; index<clipPositions[track].length; index++) {
                            if (PJGlobalTimeline.selection[track][index]) {
                                var startTick = clipPositions[track][index][0];
                                var endTick = clipPositions[track][index][1];
                                var minDuration = clips[track][index].minDuration;
                                // Find minDeltaTick
                                var minDeltaTick;
                                if (startTick%bigTickSignificance == 0)
                                    minDeltaTick = Math.max(startTick + bigTickSignificance, startTick + minDuration) - endTick;
                                else
                                    minDeltaTick = Math.max(Math.ceil(startTick/bigTickSignificance)*bigTickSignificance, startTick + minDuration) - endTick;
                                // Find maxDeltaTick
                                var maxDeltaTick;
                                if (index==clips[track].length-1) {
                                    maxDeltaTick = Infinity;
                                } else {
                                    maxDeltaTick = clips[track][index+1].startTick - endTick;
                                }
                                // Constrain deltaTick
                                deltaTick = block.clamp(deltaTick, minDeltaTick, maxDeltaTick);
                            }
                        }
                    }

                    // Displace clip startTicks in selection by deltaTick
                    block.displaceSelection(clipPositions, 0, deltaTick);

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

            // Selection or Toggle
            property var clipPositions
            onPressed: function(mouse) {
                clickTick = PJGlobalTimeline.pixelToTick(block.x + centerArea.x + mouse.x, true);
                clipPositions = block.getClipPositions();
                block.attemptSelection();
            }
            onReleased: {
                block.centerDragging = false;
                block.unpress();
            }

            // Dragging
            onMouseXChanged: function(mouse) {
                var mouseTick = PJGlobalTimeline.pixelToTick(block.x + centerArea.x + mouse.x, true);
                if (pressed && (mouseTick !== clickTick || PJGlobalTimeline.selectionDragging)) {
                    PJGlobalTimeline.selectionDragging = true;
                    block.centerDragging = true;

                    // Get bounded deltaTick
                    var deltaTick = mouseTick - clickTick - clipPositions[trackID][trackIndex][0]%PJGlobalTimeline.bigTickSignificance;
                    for (var track=0; track<clipPositions.length; track++) {
                        for (var index=0; index<clipPositions[track].length; index++) {
                            if (PJGlobalTimeline.selection[track][index]) {
                                var startTick = clipPositions[track][index][0];
                                var endTick = clipPositions[track][index][1];
                                // Find minDeltaTick
                                var minDeltaTick = -Infinity;
                                if (index==0) {
                                    minDeltaTick = -startTick;
                                } else if (!PJGlobalTimeline.selection[track][index-1]) {
                                    minDeltaTick = clips[track][index-1].endTick - startTick;
                                }
                                // Find maxDeltaTick
                                var maxDeltaTick = Infinity;
                                if (index==clips[track].length-1) {
                                    maxDeltaTick = Infinity;
                                } else if (!PJGlobalTimeline.selection[track][index+1]) {
                                    maxDeltaTick = clips[track][index+1].startTick - endTick;
                                }
                                // Constrain deltaTick
                                deltaTick = block.clamp(deltaTick, minDeltaTick, maxDeltaTick);
                            }
                        }
                    }

                    // Displace selection by deltaTick
                    block.displaceSelection(clipPositions, deltaTick, deltaTick);

                }

            }

            // Visual update for multi selection
            property bool visualSelectionUpdateNeeded: PJGlobalTimeline.visualSelectionUpdateNeeded
            onVisualSelectionUpdateNeededChanged: {
                selected = PJGlobalTimeline.selection[trackID][trackIndex];
            }
        }

    }

}
