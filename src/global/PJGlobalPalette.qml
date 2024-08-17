pragma Singleton
import QtQuick

Item {

    // Visual height of each movement within a folder, in pixels.
    property int folderItemHeight: 40

    // List containing lists representing the subsystems of the robot, which contain draggable movements onto the timeline.
    property var movements: [[]]

    // Whether or not an item is being dragged from the Palette.
    property bool paletteDragging: false

    // Reference to the focusScope QtQuick item in Main.qml.
    property var focusScope

    // Reference to the PJPaletteGhostItem QtQuick item.
    property var ghostItem

    // Reference to the PJTimelineShadowItem QtQuick item.
    property var shadowItem

    // The maximum initial duration of a new movement placed on the timeline.
    readonly property int defaultMovementDuration: 8*PJGlobalTimeline.bigTickSignificance


}
