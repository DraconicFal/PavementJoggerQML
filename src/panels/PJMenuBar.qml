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

        delegate: ItemDelegate {
            id: menuBarFile
            highlighted: ListView.isCurrentItem
            contentItem: Text {
                text: menuBarFile.text
                font: menuBarFile.font
                color: "White"
            }
            background: Rectangle {
                color: {
                    if (parent.hovered)
                        return "#29282E";
                    return "#0d0d0d";
                }
            }
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
