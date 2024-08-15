import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: zoomSlider

    signal repaintTimeline()

    Slider {
        id: slider
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        onFocusChanged: {
            if (focus) focus = false;
        }

        from: -1
        value: 3
        to: 6

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitHeight: 4
            width: slider.availableWidth
            height: implicitHeight
            radius: height/2
            color: "#141414"

            border.color: "#2c2c34"
            border.width: 0.5
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 11
            implicitHeight: width
            radius: width/2
            color: "#878787"

            border.color: "#1c1c1f"
            border.width: 1

            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 5
                implicitHeight: width
                radius: width/2
                color: slider.pressed ? "#5c5c5c" : "#878787"
            }
        }

        onValueChanged: {
            PJGlobalTimeline.secondsPerPixel = Math.pow(2, value) / 200;
            zoomSlider.repaintTimeline();
        }
    }
}
