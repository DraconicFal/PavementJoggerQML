import QtQuick
import QtQuick.Controls
import "panels"

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("PavementJogger 2")

    menuBar: PJMenuBar {}

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical

        SplitView {
            SplitView.fillHeight: true
            orientation: Qt.Horizontal

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
