pragma Singleton
import QtQuick

Item {

    // Visual height of each movement within a folder, in pixels.
    property int folderItemHeight: 40

    // List containing the palette subsystem folder objects.
    property var folders: []

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
