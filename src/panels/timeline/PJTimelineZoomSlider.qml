import QtQuick
import QtQuick.Controls
import PavementJogger

Item {
    id: zoomSlider

    signal repaintTimeline()

    Item {
        id: customSlider
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 30
        property real from: -1
        property real to: 6
        property real value: 3
        property bool pressed: false

        signal valueUpdated(real value)

        Rectangle {
            id: background
            anchors.verticalCenter: parent.verticalCenter
            x: 0
            y: height / 2 - 2
            width: parent.width
            height: 4
            radius: height / 2
            color: "#141414"
            border.color: "#2c2c34"
            border.width: 0.5
        }

        Rectangle {
            id: handle
            anchors.verticalCenter: parent.verticalCenter
            x: (customSlider.value - customSlider.from) / (customSlider.to - customSlider.from) * (background.width - handle.width)
            y: background.y - handle.height / 2 + background.height / 2
            width: 11
            height: 11
            radius: width / 2
            color: "#878787"
            border.color: "#1c1c1f"
            border.width: 1

            Rectangle {
                anchors.centerIn: parent
                width: 5
                height: 5
                radius: width / 2
                color: customSlider.pressed ? "#5c5c5c" : "#878787"
            }

            MouseArea {
                id: handleArea
                anchors.fill: parent
                onPressed: {
                    customSlider.pressed = true;
                }
                onReleased: {
                    customSlider.pressed = false;
                }
                onPositionChanged: function(mouse) {
                    if (pressed) {
                        var mappedPosition = mapToItem(background, mouse.x, mouse.y);
                        var newValue = customSlider.from + (mappedPosition.x / background.width) * (customSlider.to - customSlider.from);

                        customSlider.value = Math.min(customSlider.to, Math.max(customSlider.from, newValue));
                        customSlider.valueUpdated(customSlider.value);
                    }
                }
            }
        }

        onValueUpdated: {
            PJGlobalTimeline.secondsPerPixel = Math.pow(2, value) / 200;
            zoomSlider.repaintTimeline();
        }

        onPressedChanged: {
            PJGlobalTimeline.zoomSliderDragging = pressed;
        }
    }

}
