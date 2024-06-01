import QtQuick
import QtQuick.Window
import QtQuick.Controls.Windows

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("PavementJogger 2")

    menuBar: PJMenuBar {}

    PJFieldView {
        id: pj_fieldView

        anchors.bottom: pj_timeline.top
        anchors.top: parent.top
        anchors.left: pj_palette.right
        anchors.right: pj_properties.left
    }

    PJPalette {
        id: pj_palette

        width: 250
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    PJProperties {
        id: pj_properties

        width: 250
        height: parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: pj_timeline.top
    }

    PJTimeline {
        id: pj_timeline

        width: parent.width
        height: 250
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.right: parent.right
    }

}
