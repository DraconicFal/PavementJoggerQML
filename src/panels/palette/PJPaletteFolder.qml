import QtQuick
import PavementJogger

Item {
    id: folder
    height: background.height + separatorThickness
    clip: true

    // The number ID of the track that this folder represents.
    property int trackID: -1

    // Robot subsystem that this folder represents.
    property string folderName: ""

    // Contains all the movements within this folder.
    property var movements: []

    // Visual display component.
    property var folderItems

    // Property to track the expanded/collapsed state.
    property bool expanded: false
    onExpandedChanged: {
        if (expanded) {
            var itemsHeight = movements.length * PJGlobalPalette.folderItemHeight;
            background.height = titleButton.height + itemsHeight;
            separator.opacity = 1;
        } else {
            background.height = titleButton.height;
            separator.opacity = 0;
        }
    }


    /////////////
    // VISUALS //
    /////////////

    /// BACKGROUND ///
    Rectangle {
        id: background
        clip: true
        radius: 4
        color: titleButton.color

        /// SCALING ///
        width: parent.width
        height: titleButton.height

        // Height animation
        Behavior on height {
            PropertyAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        /// FOLDER TITLE BUTTON ///
        Rectangle {
            id: titleButton
            anchors.top: background.top
            anchors.left: background.left
            anchors.right: background.right
            height: 30
            radius: background.radius
            z: 1

            // Color animation
            color: mouseArea.getBackgroundColor()
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            // Toggle expanded and determine background colors
            MouseArea {
                id: mouseArea
                anchors.fill: parent

                property bool hovering: false
                hoverEnabled: true
                onEntered: hovering = true
                onExited: hovering = false

                function getBackgroundColor() {
                    if (pressed) {
                        return "#004368";
                    }
                    if (hovering) {
                        return "#434344";
                    }
                    return "#29282E";
                }

                onClicked: expanded = !expanded
            }

            // Title icon and text
            Image {
                id: expandIcon
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                // Positioning
                x: 10

                // Visual
                source: "qrc:/Images/assets/double-arrow.png"
                scale: 0.5
            }
            Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter

                // Positioning
                x: 40
                width: parent.width - x - 5

                // Visual
                font.pixelSize: 13
                color: "#cccccc"
                text: folderName
                elide: Text.ElideRight
            }
        }
    }

    /// VISUAL SEPARATOR ///
    readonly property double separatorThickness: 2
    Rectangle {
        id: separator

        x: 0
        y: folder.height - separatorThickness
        width: folder.width
        height: separatorThickness

        color: "#09090A"
        opacity: 0
        Behavior on opacity {
            PropertyAnimation {
                duration: 150
                easing.type: Easing.Linear
            }
        }
    }


    ///////////
    // ITEMS //
    ///////////

    // Dynamically load the folderItems if set.
    Component.onCompleted: {
        if (typeof(folder.folderItems) !== "undefined") {
            folder.folderItems.parent = background;
            folder.folderItems.anchors.top = titleButton.bottom;
            folder.folderItems.width = folder.width;
        }
    }

    onFolderItemsChanged: {
        if (typeof(folder.folderItems) !== "undefined") {
            folder.folderItems.parent = background;
            folder.folderItems.anchors.top = titleButton.bottom;
            folder.folderItems.width = folder.width;
        }
    }

}


