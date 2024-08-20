import QtQuick
import PavementJogger

Item {
    id: attributes

    // The number ID of the track this movement belongs on.
    property int trackID

    // The name of this movement.
    property string movementName


    /////////////
    // VISUALS //
    /////////////
    height: PJGlobalPalette.folderItemHeight

    Rectangle {
        id: block
        clip: true
        radius: 4

        /// POSITIONING ///
        property double visualMargin: 3
        width: parent.width - 2*visualMargin
        height: parent.height - 2*visualMargin
        x: visualMargin
        y: visualMargin

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
            border.width: 0.5
            border.color: "#030303"

            // Animate the border color when hovering
            Behavior on border.color {
                ColorAnimation {
                    duration: 100
                }
            }

            // Animate the border width when hovering
            Behavior on border.width {
                PropertyAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
        }

        /// MOUSE INTERACTION ///
        MouseArea {
            id: dragArea
            anchors.fill: parent
            hoverEnabled: true

            // Hover detection
            property bool hovering: false
            onEntered: {
                hovering = true;
                border.border.width = 2;
                border.border.color = PJGlobalTimeline.hsv2rgb(75*trackID, 0.5839, 1);
            }
            onExited: {
                hovering = false;
                if (!dragging) {
                    border.border.width = 0.5;
                    border.border.color ="#030303";
                }
            }

            // Drag detection
            property bool dragging: false
            property double clickX
            property double clickY
            onPressed: function(mouse) {
                clickX = mouse.x;
                clickY = mouse.y;
            }
            onPositionChanged: function(mouse) {
                if ((mouse.x!==clickX || mouse.y!==clickY) && pressed && !dragging) {
                    startDrag();
                    dragging = true;
                }
            }
            onReleased: {
                if (dragging) {
                    stopDrag();
                    dragging = false;
                }
                if (!hovering) {
                    border.border.width = 0.5;
                    border.border.color ="#030303";
                }
            }
        }

    }



    ////////////////
    // GHOST ITEM //
    ////////////////

    // Functions
    function startDrag() {
        if (dragArea.containsMouse) {
            var ghostItem = PJGlobalPalette.ghostItem;
            var focusScope = PJGlobalPalette.focusScope;
            var grabber = block.grabToImage(function(result) {
                ghostItem.source = result.url;
                ghostItem.visible = true;
                var globalPosition = mapToItem(focusScope, dragArea.mouseX, dragArea.mouseY);
                ghostItem.x = globalPosition.x - ghostItem.width / 2;
                ghostItem.y = globalPosition.y - ghostItem.height / 2;
                ghostItem.validTarget = false;
                ghostItem.targetTrackID = trackID;
                ghostItem.targetTick = -1;
            });

            dragArea.onPositionChanged.connect(moveGhost);
            PJGlobalPalette.paletteDragging = true;

        }
    }

    function moveGhost(mouse) {
        var ghostItem = PJGlobalPalette.ghostItem;
        var focusScope = PJGlobalPalette.focusScope;
        var globalPosition = mapToItem(focusScope, mouse.x, mouse.y);
        ghostItem.x = globalPosition.x - ghostItem.width / 2;
        ghostItem.y = globalPosition.y - ghostItem.height / 2;
    }

    function stopDrag() {
        // Disable ghost item
        var ghostItem = PJGlobalPalette.ghostItem;
        ghostItem.visible = false;
        dragArea.onPositionChanged.disconnect(moveGhost);
        PJGlobalPalette.paletteDragging = false;
        PJGlobalPalette.shadowItem.hide();

        // Create clip item if valid target found
        if (!ghostItem.validTarget) return;

        // Create clip component
        var clipComponent = Qt.createComponent("qrc:/components/src/panels/timeline/PJTimelineClip.qml");
        if (clipComponent.status !== Component.Ready) {
            console.exception("Error loading clipComponent:", clipComponent.errorString());
            return;
        }

        // Create clip item
        var clip = clipComponent.createObject(PJGlobalTimeline.timelineTracksItem, {
            "movementName": movementName,
            "trackID": ghostItem.targetTrackID,
            "trackIndex": ghostItem.targetIndex,
            "startTick": ghostItem.targetStartTick,
            "endTick": ghostItem.targetEndTick,
            "minDuration": 0
        });
        if (clip === null) {
            console.exception("Error creating clip item from Palette");
            return;
        }


        console.log(`\nInserting a clip for ${movementName} at index ${ghostItem.targetIndex}!`);
        console.log(`---- Track ${ghostItem.targetTrackID}: (${ghostItem.targetStartTick},${ghostItem.targetEndTick})`);
        console.log(`Old clips array`);
        for (var i=0; i<PJGlobalTimeline.clips.length; i++) {
            var track = PJGlobalTimeline.clips[i];
            var names = "";
            for (var j=0; j<track.length; j++) {
                names += `(${track[j].startTick},${track[j].endTick}); `;
            }
            console.log(`---- Track ${i}: ${names}`);
        }

        // Insert clip if valid
        PJGlobalTimeline.clips[trackID].splice(ghostItem.targetIndex, 0, clip);

        // Update for calling clipsChanged signal
        var new_clips = PJGlobalTimeline.clips;
        PJGlobalTimeline.clips = new_clips;

        console.log(`New clips array`);
        for (i=0; i<PJGlobalTimeline.clips.length; i++) {
            track = PJGlobalTimeline.clips[i];
            names = "";
            for (j=0; j<track.length; j++) {
                names += `(${track[j].startTick},${track[j].endTick}); `;
            }
            console.log(`---- Track ${i}: ${names}`);
        }

    }

}
