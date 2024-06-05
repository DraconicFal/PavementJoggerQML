import QtQuick
import QtQuick.Controls

MenuBar {
    id: pj_menuBar



    Menu { //File
        title: qsTr("File")
        Action {
            text: qsTr("New Project...")
        }
        Action { text: qsTr("Open Project...") }
        Action { text: qsTr("Exit") }
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

    Menu { //Edit
        title: qsTr("Edit")
        Action {
            text: qsTr("Undo")
        }
        Action { text: qsTr("Redo") }
        Action { text: qsTr("Copy") }

        delegate: ItemDelegate {
            id: menuBarEdit
            highlighted: ListView.isCurrentItem
            contentItem: Text {
                text: menuBarEdit.text
                font: menuBarEdit.font
                color: "white"
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

    Menu { //View
        title: qsTr("View")
        id: menuView
        property bool isMaximized: false

        Action {
            text: qsTr("Reset View")
            onTriggered: {
                pj_palette.width = pj_palette.startWidth
                pj_properties.width = pj_properties.startWidth
                pj_timeline.height = pj_timeline.startHeight
                pj_palette.SplitView.preferredWidth = pj_palette.startWidth
                pj_properties.SplitView.preferredWidth = pj_properties.startWidth
                pj_timeline.SplitView.preferredHeight = pj_timeline.startHeight
            }
        }
        Action {
            text: qsTr("Maximize")
            //enabled: !isMaximized
            onTriggered: {
                //isMaximized: true
                mainWindow.visibility = Window.Maximized
            }
            enabled: false
        }
        Action {
            text: qsTr("Minimize")
            //enabled: isMaximized
            onTriggered: {
                //isMaximized: false
                mainWindow.visibility = Window.Minimized
            }
        }

        delegate: ItemDelegate {
            id: menuBarView
            highlighted: ListView.isCurrentItem
            contentItem: Text {
                text: menuBarView.text
                font: menuBarView.font
                color: enabled ? "white" : "gray"
            }
            background: Rectangle {
                color: {
                    if (parent.hovered && enabled)
                        return "#29282E";
                    return "#0d0d0d";
                }
            }
        }
    }

    Menu { //Timeline
        title: qsTr("Timeline")
        Action {
            text: qsTr("Translation")
        }
        Action { text: qsTr("Rotation") }
        Action { text: qsTr("Exitongus") }

        delegate: ItemDelegate {
            id: menuBarTimeline
            highlighted: ListView.isCurrentItem
            contentItem: Text {
                text: menuBarTimeline.text
                font: menuBarTimeline.font
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
