import QtQuick

Rectangle {
    width: parent.width
    height: 5 // Vertical Padding
    color: "#0d0d0d"

    Rectangle {
        width: parent.width - 20 // Side Padding
        height: 1
        color: "#39383E"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
