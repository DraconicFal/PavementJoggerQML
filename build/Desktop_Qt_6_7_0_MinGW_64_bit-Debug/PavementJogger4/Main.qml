import QtQuick
import QtQuick.Window
import QtQuick.Controls.Windows

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Pavement Jogger")

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem {
                text: "Amongus"
            }
        }
    }

    Rectangle {
        id: palleteBackground
        width: 250
        height: parent.height
        color: "#5f5f5f"
        //anchors.verticalCenter: mainWindow.verticalCenter
        anchors.left: parent.left
        anchors.top: parent.top

        Rectangle {
            id: palleteTitle
            anchors.top: parent.top
        }

        Column {
            id: columnPallete
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            visible: true
        }
    }

    Rectangle {
        id: propertiesBackground
        width: 250
        height: parent.height
        color: "#5f5f5f"
        anchors.right: parent.right
        anchors.top: parent.top

        Column {
            id: columnProperties
            x:0
            y:0
            width: parent.width
            height: parent.height

        }
    }

    Rectangle {
        id: timelineBackground
        width: parent.width
        height: 250
        color: "#2d2d2d"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.right: parent.right

        Column {
            id: columnTimeline
            x:0
            y:0
            width: parent.width
            height: parent.height

        }
    }
}
