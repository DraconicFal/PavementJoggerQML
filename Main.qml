import QtQuick
import QtQuick.Window
import QtQuick.Controls.Windows

Window {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Pavement Jogger")

    Column {
        id: columnPallete
        x: 0
        y: 0
        width: 250
        height: mainWindow.height
        visible: true
        //anchors.verticalCenter: mainWindow.verticalCenter
        anchors.left: mainWindow.left
        //anchors.right: mainWindow.right
        anchors.top: mainWindow.top
        //anchors.bottom: columnTimeline.
        //anchors.bottom: columnTimeline.TopLeft
        //anchors.leftMargin: -470
        //anchors.rightMargin: -30
        //anchors.topMargin: -184
        //anchors.bottomMargin: -322
        //anchors.horizontalCenter: imagetest.horizontalCenter

        Rectangle {
            id: palleteBackground
            width: columnPallete.width
            height: columnPallete.height
            color: "#5f5f5f"
            anchors.centerIn: columntest
        }
    }

    Column {
        id: columnTimeline
        x:0
        y:0
        width: 250
        height:250
        anchors.bottom: mainWindow.bottom
        anchors.left: mainWindow.left
        anchors.right: mainWindow.right

        Rectangle {
            id: timelineBackground
            width: columnTimeline.width
            height: columnTimeline.height
            color: "#2d2d2d"
            anchors.centerIn: columnTimeline
        }
    }
}
