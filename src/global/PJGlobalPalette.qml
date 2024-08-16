pragma Singleton
import QtQuick

Item {

    // Visual height of each movement within a folder, in pixels.
    property int folderItemHeight: 40

    // List containing lists representing the subsystems of the robot, which contain draggable movements onto the timeline.
    property var movements: [[]]

    // Whether or not an item is being dragged from the Palette.
    property bool paletteDragging: false


}
