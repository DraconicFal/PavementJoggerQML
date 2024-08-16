import QtQuick
import QtQuick.Controls
import PavementJogger
import "panels/fieldview"
import "panels/menubar"
import "panels/palette"
import "panels/properties"
import "panels/timeline"

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

    // Read in project file on completion
    Component.onCompleted: {
        PJGlobalTimeline.tracks = projectXmlHandler.getTimelineTrackNames(PJGlobalProject.projectPath);
        PJGlobalTimeline.clips = projectXmlHandler.getTimelineClips(PJGlobalProject.projectPath, PJGlobalTimeline.clips, true);
    }

    //////////////
    // MENU BAR //
    //////////////
    menuBar: PJMenuBar {
        id: menuBar
        onFocusChanged: {
            if (focus) {
                focusScope.forceActiveFocus();
            }
        }
    }

    /////////////////////////////////////////////////
    // Catch all keyboard inputs at the Root Level //
    /////////////////////////////////////////////////
    FocusScope {
        id: focusScope
        anchors.top: menuBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true

        /////////////////////
        // KEYBIND HANDLER //
        /////////////////////
        Keys.onPressed: (event)=>PJGlobalKeyboard.processEvent(event, true);
        Keys.onReleased: (event)=>PJGlobalKeyboard.processEvent(event, false);
        PJKeybindHandler {}


        ///////////////
        // SPLITVIEW //
        ///////////////
        SplitView {
            id: containerSplitView
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
                property int maximumHeight: Math.min(700, focusScope.height-fieldView.minimumHeight)

                SplitView.minimumHeight: minimumHeight
                SplitView.maximumHeight: maximumHeight
                SplitView.fillHeight: true
                implicitHeight: 300

            }

        }

        /// PALETTE DRAGGING GHOST ITEM ///
        property alias ghostItem: ghostItem
        Image {
            id: ghostItem
            visible: false
            fillMode: Image.PreserveAspectFit
            opacity: 0.75
            scale: 0.75

            // Ghost item information
            property bool validTarget: false
            property int targetTrackID: -1
            property int targetTick: -1

            onXChanged: cursorArea.cursorShape = cursorArea.getCursorShape()
            onYChanged: cursorArea.cursorShape = cursorArea.getCursorShape()

            MouseArea {
                id: cursorArea
                anchors.fill: parent
                cursorShape: getCursorShape()

                // Detect whether or not there is a valid space to place the clip
                function getCursorShape() {
                    var tracks = timeline.content.tracks;
                    var timelinePosition = mapToItem(tracks, mouseX+ghostItem.width/2, mouseY+ghostItem.height/2);

                    // Check if cursor is within timeline track bounds
                    if (timelinePosition.x<0 || tracks.width<timelinePosition.x ||
                            timelinePosition.y<0 || tracks.height<timelinePosition.y) {
                        ghostItem.validTarget = false;
                        ghostItem.targetTick = -1;
                        return Qt.ForbiddenCursor;
                    }

                    // Determine the target track
                    var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
                    var trackHeight = PJGlobalTimeline.trackHeight;

                    var startPixel = verticalPixelScroll % trackHeight - trackHeight;
                    var startIndex = Math.ceil(verticalPixelScroll / trackHeight)+1;
                    if (trackHeight*(ghostItem.targetTrackID+startIndex-1)<=timelinePosition.y && timelinePosition.y<trackHeight*(ghostItem.targetTrackID+startIndex)) {


                        //TODO: Test to see if there is a valid space to insert the new clip


                        ghostItem.validTarget = true;
                        ghostItem.targetTick = PJGlobalTimeline.pixelToTick(timelinePosition.x, true);
                        return Qt.DragMoveCursor;
                    }

                    ghostItem.validTarget = false;
                    ghostItem.targetTick = -1;
                    return Qt.ForbiddenCursor;
                }

            }

        }

    }

}
