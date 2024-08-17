import QtQuick
import PavementJogger

Image {
    id: ghostItem
    visible: false
    fillMode: Image.PreserveAspectFit
    opacity: 0.75
    scale: 0.75

    Component.onCompleted: PJGlobalPalette.ghostItem = ghostItem

    // Ghost item information
    property bool validTarget: false
    property int targetTrackID: -1
    property int targetIndex: -1
    property int targetStartTick: -1
    property int targetEndTick: -1

    onXChanged: cursorArea.update()
    onYChanged: cursorArea.update()

    MouseArea {
        id: cursorArea
        anchors.fill: parent
        cursorShape: Qt.ForbiddenCursor

        // Detect whether or not there is a valid space to place the clip and return the corresponding cursor sprite.
        function update() {
            if (cursorArea.updateCursor()) {
                PJGlobalPalette.shadowItem.showAt(targetTrackID, targetStartTick, targetEndTick);
            } else {
                PJGlobalPalette.shadowItem.hide();
            }
        }

        function updateCursor() {

            // INVALID if there are not enough tracks in the timeline
            if (PJGlobalTimeline.clips.length < targetTrackID) {
                ghostItem.validTarget = false;
                ghostItem.targetIndex = -1;
                ghostItem.targetStartTick = -1;
                ghostItem.targetEndTick = -1;
                cursorArea.cursorShape = Qt.ForbiddenCursor;
                return false;
            }


            // INVALID if cursor is outside of timeline track bounds
            var tracks = mainWindow.pj_timeline.content.tracks;
            var timelinePosition = mapToItem(tracks, mouseX+ghostItem.width/2, mouseY+ghostItem.height/2);

            if (timelinePosition.x<0 || tracks.width<timelinePosition.x ||
                    timelinePosition.y<0 || tracks.height<timelinePosition.y) {
                ghostItem.validTarget = false;
                ghostItem.targetIndex = -1;
                ghostItem.targetStartTick = -1;
                ghostItem.targetEndTick = -1;
                cursorArea.cursorShape = Qt.ForbiddenCursor;
                return false;
            }


            // INVALID if cursor is in wrong track
            var verticalPixelScroll = PJGlobalTimeline.verticalPixelScroll;
            var trackHeight = PJGlobalTimeline.trackHeight;

            var startPixel = verticalPixelScroll % trackHeight - trackHeight;
            var startIndex = Math.ceil(verticalPixelScroll / trackHeight)+1;
            if (timelinePosition.y < trackHeight*(targetTrackID+startIndex-1) ||
                    trackHeight*(targetTrackID+startIndex) < timelinePosition.y) {
                ghostItem.validTarget = false;
                ghostItem.targetIndex = -1;
                ghostItem.targetStartTick = -1;
                ghostItem.targetEndTick = -1;
                cursorArea.cursorShape = Qt.ForbiddenCursor;
                return false;
            }


            // VALID placement if track is empty or if placed at end of track
            var targetStartTick = PJGlobalTimeline.pixelToTick(timelinePosition.x, true);
            var track = PJGlobalTimeline.clips[targetTrackID];

            if (track.length===0 ||
                    track[track.length-1].endTick <= targetStartTick) {
                ghostItem.validTarget = true;
                ghostItem.targetIndex = track.length===0 ? 0 : track.length;
                ghostItem.targetStartTick = targetStartTick;
                ghostItem.targetEndTick = targetStartTick+PJGlobalPalette.defaultMovementDuration;
                cursorArea.cursorShape = Qt.DragMoveCursor;
                return true;
            }


            // Compare against other clips in the track
            var insertionIndex = 0;
            for (var index=0; index<track.length; index++) {

                // INVALID placement if intersects another clip
                if (track[index].startTick <= targetStartTick && targetStartTick < track[index].endTick) {
                    ghostItem.validTarget = false;
                    ghostItem.targetIndex = -1;
                    ghostItem.targetStartTick = -1;
                    ghostItem.targetEndTick = -1;
                    cursorArea.cursorShape = Qt.ForbiddenCursor;
                    return false;
                }

                var tickDifference = track[index].startTick - targetStartTick;
                // INVALID placement if too close to next clip
                if (0 < tickDifference && tickDifference < PJGlobalTimeline.bigTickSignificance) {
                    ghostItem.validTarget = false;
                    ghostItem.targetIndex = -1;
                    ghostItem.targetStartTick = -1;
                    ghostItem.targetEndTick = -1;
                    cursorArea.cursorShape = Qt.ForbiddenCursor;
                    return false;
                }

                // VALID placement if there is enough space to the next clip
                if (0 < tickDifference) {
                    ghostItem.validTarget = true;
                    ghostItem.targetIndex = index;
                    ghostItem.targetStartTick = targetStartTick;
                    ghostItem.targetEndTick = targetStartTick + Math.min(tickDifference, PJGlobalPalette.defaultMovementDuration);
                    cursorArea.cursorShape = Qt.DragMoveCursor;
                    return true;
                }
            }

        }

    }

}
