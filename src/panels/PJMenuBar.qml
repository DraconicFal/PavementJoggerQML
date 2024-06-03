import QtQuick
import QtQuick.Controls

MenuBar {
    id: pj_menuBar
    Menu {
        title: qsTr("File")
        Action {
            text: qsTr("New Project...")
        }
        Action { text: qsTr("AMONG US") }
        Action { text: qsTr("VERY SUS") }
        Action { text: qsTr("SUSSY AMONGUS") }
        Action { text: qsTr("SUSSY SUS AMOGUS") }

        delegate: MenuBarItem {
            id: menuBarItem1

            contentItem: Text {
                text: menuBarItem1.text
                font: menuBarItem1.font
                opacity:  enabled ? 1.0 : 0.3
                color: menuBarItem1.highlighted ? "#ffffff" : "#ffffff"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 20
                opacity: enabled ? 1 : 0.3
                color: menuBarItem1.highlighted ? "#29282E" : "transparent"
            }
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 20
            color: "#0d0d0d"
        }
    }

    delegate: MenuBarItem {
        id: menuBarItem

        contentItem: Text {
            text: menuBarItem.text
            font: menuBarItem.font
            opacity: enabled ? 1.0 : 0.3
            color: menuBarItem.highlighted ? "#ffffff" : "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? "#29282E" : "transparent"
        }
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 20
        color: "#0d0d0d"

        Rectangle {
            color: "#000000"
            width: parent.width
            height: 2
            anchors.bottom: parent.bottom
        }
    }
}
