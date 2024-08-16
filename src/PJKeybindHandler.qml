import QtQuick
import PavementJogger

Item {


    //////////////
    // TIMELINE //
    //////////////

    // Clip deletion
    readonly property bool backspacePressed: PJGlobalKeyboard.backspacePressed
    readonly property bool deletePressed: PJGlobalKeyboard.deletePressed

    onBackspacePressedChanged: attemptDeleteSelection()
    onDeletePressedChanged: attemptDeleteSelection()

    function attemptDeleteSelection() {
        // See if selection exists
        var selection = PJGlobalTimeline.selection;
        const testTrue = (element) => element === true;
        const testTrack = (track) => track.some(testTrue);
        if ((backspacePressed || deletePressed) && selection.some(testTrack)) {
            // Loop through to filter out and destroy selected clips
            var clips = PJGlobalTimeline.clips;
            var filteredClips = [];
            for (var track=0; track<clips.length; track++) {
                filteredClips.push([]);
                for (var index=0; index<clips[track].length; index++) {
                    if (selection[track][index]) {
                        clips[track][index].destroy();
                    } else {
                        filteredClips[track].push(clips[track][index]);
                    }
                }
            }
            // Replace current clips with new array
            PJGlobalTimeline.clips = filteredClips;
        }
    }

}
