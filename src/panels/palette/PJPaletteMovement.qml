import QtQuick
import PavementJogger

Item {

    // The number ID of the track this movement belongs on.
    property int trackID

    // The name of this movement.
    property string movementName


    /////////////
    // VISUALS //
    /////////////
    width: parent.width
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
            var grabber = block.grabToImage(function(result) {
                ghostItem.source = result.url;
                ghostItem.visible = true;
                var globalPosition = mapToItem(focusScope, dragArea.mouseX, dragArea.mouseY);
                ghostItem.x = globalPosition.x - ghostItem.width / 2;
                ghostItem.y = globalPosition.y - ghostItem.height / 2;
            });

            dragArea.onPositionChanged.connect(moveGhost);
            PJGlobalPalette.paletteDragging = true;

        }
    }

    function moveGhost(mouse) {
        var globalPosition = mapToItem(focusScope, mouse.x, mouse.y);
        ghostItem.x = globalPosition.x - ghostItem.width / 2;
        ghostItem.y = globalPosition.y - ghostItem.height / 2;
    }

    function stopDrag() {
        ghostItem.visible = false;
        dragArea.onPositionChanged.disconnect(moveGhost);
        PJGlobalPalette.paletteDragging = false;
    }

}
