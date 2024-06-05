import QtQuick
import QtQuick.Controls
import "panels/fieldview"
import "panels/menubar"
import "panels/palette"
import "panels/properties"
import "panels/timeline"

ApplicationWindow {
    id: mainWindow

    // setup main window
    color: "#1A1A1A"
    minimumWidth: screen.width / 2
    minimumHeight: screen.height / 2
    width: screen.width * (2/3)
    height:screen.height * (2/3)
    visible: true
    title: qsTr("PavementJogger 2")

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
                property int startWidth: implicitWidth

                SplitView.minimumWidth: 100
                SplitView.maximumWidth: 500
                implicitWidth: (SplitView.minimumWidth + SplitView.maximumWidth) / 2
            }

            PJFieldView {
                id: pj_fieldView

                SplitView.minimumWidth: 200
                SplitView.fillWidth: true
            }

            PJProperties {
                id: pj_properties
                property int startWidth: implicitWidth

                SplitView.minimumWidth: 100
                SplitView.maximumWidth: 500
                implicitWidth: (SplitView.minimumWidth + SplitView.maximumWidth) / 2
            }
        }

        PJTimeline {
            id: pj_timeline
            property int startHeight: implicitHeight

            implicitHeight: 400
            SplitView.maximumHeight: 600
            SplitView.minimumHeight: 200
            SplitView.fillHeight: true
        }
    }




}
