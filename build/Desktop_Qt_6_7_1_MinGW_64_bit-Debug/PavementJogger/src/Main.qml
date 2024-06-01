import QtQuick
import QtQuick.Controls
import "panels"

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("PavementJogger 2")

    // setup main window
    color: "#1A1A1A"
    minimumWidth: screen.width
    // maximumWidth: 2*minimumWidth
    minimumHeight: screen.height
    // maximumHeight: 2*minimumHeight

    menuBar: PJMenuBar {}

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical
        handle: Rectangle {
            implicitHeight: 3
            color: "#09090A"
        }

        SplitView {
            SplitView.fillHeight: true
            orientation: Qt.Horizontal
            handle: Rectangle {
                implicitWidth: 3
                color: "#09090A"
            }

            PJPalette {
                id: pj_palette

                implicitWidth: 200
                SplitView.minimumWidth: 100
                SplitView.maximumWidth: 500
            }

            PJFieldView {
                id: pj_fieldView

                SplitView.minimumWidth: 200
                SplitView.fillWidth: true
            }

            PJProperties {
                id: pj_properties

                implicitWidth: 200
                SplitView.minimumWidth: 100
                SplitView.maximumWidth: 500
            }
        }

        PJTimeline {
            id: pj_timeline

            implicitHeight: 250
            SplitView.maximumHeight: 400
            SplitView.minimumHeight: 100
            SplitView.fillHeight: true
        }
    }




}
