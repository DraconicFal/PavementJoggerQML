import QtQuick
import PavementJogger

MouseArea {
    id: scrollArea

    signal repaintTimeline()

    // Allow propagation settings
    propagateComposedEvents: true
    onPressed: function(mouse) {mouse.accepted = false;}
    onReleased: function(mouse) {mouse.accepted = false;}

    // Enable scrolling
    scrollGestureEnabled: true

    onWheel: function(wheel) {
        var deltaX = wheel.angleDelta.x;
        var kY = 0.1
        var deltaY = wheel.angleDelta.y * kY;
        if (PJGlobalKeyboard.shiftPressed && !PJGlobalKeyboard.ctrlPressed) {
            deltaX += wheel.angleDelta.y;
            deltaY = 0;
        }
        if (PJGlobalKeyboard.ctrlPressed && !PJGlobalKeyboard.shiftPressed) {
            PJGlobalTimeline.trackHeight = Math.min(2*PJGlobalTimeline.initTrackHeight, Math.max(PJGlobalTimeline.initTrackHeight/2, PJGlobalTimeline.trackHeight+2*Math.sign(deltaY)));
            deltaX = 0;
            deltaY = 0;
        }

        PJGlobalTimeline.scrollHorizontally(deltaX);
        PJGlobalTimeline.scrollVertically(deltaY);
        scrollArea.repaintTimeline();
    }

}
