import QtQuick
import QtQuick.Controls
import PavementJogger
import "panels/fieldview"
import "panels/menubar"
import "panels/palette"
import "panels/properties"
import "panels/timeline"
import "panels/palette/prefabs"

ApplicationWindow {
    id: mainWindow
    property alias pj_menuBar: menuBar
    property alias pj_palette: palette
    property alias pj_fieldView: fieldView
    property alias pj_properties: properties
    property alias pj_timeline: timeline

    // Setup main window
    color: "#1A1A1A"
    minimumWidth: screen.width / 2
    minimumHeight: screen.height / 2
    width: screen.width * (2/3)
    height: screen.height * (2/3)
    visible: true
    title: qsTr("PavementJogger 2")

    // Read in XML track names on completion
    Component.onCompleted: {
        PJGlobalTimeline.tracks = projectXmlHandler.getTrackNames(PJGlobalProject.projectPath);
    }

    //////////////
    // MENU BAR //
    //////////////
    menuBar: PJMenuBar {
        id: menuBar
        property string name: "I am PJMenuBar"
    }

    /////////////////////////////////////////////////
    // Catch all keyboard inputs at the Root Level //
    /////////////////////////////////////////////////
    FocusScope {
        id: focusScope
        anchors.fill: parent
        focus: true

        property string name: "I am focus scope"

        Keys.onPressed: (event)=>PJGlobalKeyboard.setEvent(event);
        Keys.onReleased: (event)=>PJGlobalKeyboard.setEvent(event);

        ///////////////
        // SPLITVIEW //
        ///////////////
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

                /////////////
                // PALETTE //
                /////////////
                PJPalette {
                    id: palette
                    property int startWidth: implicitWidth
                    property int minimumWidth: 100
                    property int maximumWidth: 500

                    SplitView.minimumWidth: minimumWidth
                    SplitView.maximumWidth: maximumWidth
                    implicitWidth: (minimumWidth + maximumWidth) / 2

                    // Button {
                    //     id: control
                    //     anchors.centerIn: parent
                    //     function createNewDraggableObj() {
                    //         var component = Qt.createComponent("panels/palette/prefabs/DraggableObj.qml");
                    //         component.createObject(timeline.content.tracks, {"x": 0, "y": 0});
                    //     }
                    //     width: parent.width-PJGlobalTimeline.trackHeight
                    //     height: PJGlobalTimeline.trackHeight
                    //     onClicked: createNewDraggableObj()
                    // }
                }

                ////////////////
                // FIELD VIEW //
                ////////////////
                PJFieldView {
                    id: fieldView
                    property int minimumWidth: 200
                    property int minimumHeight: 200

                    SplitView.minimumWidth: minimumWidth
                    SplitView.minimumHeight: minimumHeight
                    SplitView.fillWidth: true
                }

                ////////////////
                // PROPERTIES //
                ////////////////
                PJProperties {
                    id: properties
                    property int startWidth: implicitWidth
                    property int minimumWidth: 100
                    property int maximumWidth: 500

                    SplitView.minimumWidth: minimumWidth
                    SplitView.maximumWidth: maximumWidth
                    implicitWidth: (minimumWidth + maximumWidth) / 2
                }
            }

            //////////////
            // TIMELINE //
            //////////////
            PJTimeline {
                id: timeline
                property int startHeight: implicitHeight
                property int minimumHeight: 100
                property int maximumHeight: 700

                SplitView.minimumHeight: minimumHeight
                SplitView.maximumHeight: maximumHeight
                SplitView.fillHeight: true
                implicitHeight: 300
            }

        }

    }

}
