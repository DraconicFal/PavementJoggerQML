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

    Image {
        id: test
        source: "qrc:/Images/PavementJoggerLogo.png"
        anchors.bottom: timelineBackground.top
        anchors.top: parent.top
        anchors.left: palleteBackground.right
        anchors.right: propertiesBackground.left
    }

    Rectangle {
        id: palleteBackground
        width: 250
        height: parent.height
        color: "#3d3d3d"
        //anchors.verticalCenter: mainWindow.verticalCenter
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: timelineBackground.top

        Rectangle {
            id: palleteTitle
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#242424"

            Text {
                id: palleteTitleText
                text: qsTr("Pallete")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "#ffffff"
            }
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
        color: "#3d3d3d"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: timelineBackground.top

        Rectangle {
            id: propertiesTitle
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#242424"

            Text {
                id: propertiesTitleText
                text: qsTr("Properties")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "#ffffff"
            }
        }

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
        color: "#3d3d3d"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: timelineTitle
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#242424"

            Text {
                id: timelineTitleText
                text: qsTr("Timeline")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "#ffffff"
            }
        }

        Column {
            id: columnTimeline
            x:0
            y:0
            width: parent.width
            height: parent.height

        }
    }
}
