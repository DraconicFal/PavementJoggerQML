import QtQuick

Item {
    id: fieldView
    property int originalWidth;
    property int currentWidth;

    Image {
        id: testImage
        anchors.fill: parent
        source: "qrc:/Images/assets/centerstage_field.png"
        fillMode: Image.PreserveAspectFit

        // Save original image width
        asynchronous: true
        onStatusChanged: {
            if (status == Image.Ready) {
                fieldView.originalWidth = sourceSize.width;
            }
        }

        // Update currentWidth when resizing panels
        onHeightChanged: {
            fieldView.currentWidth = Math.min(width, height);
            console.log(`currentWidth ${currentWidth}`);
            console.log(`fieldViewRobot offsetX ${fieldViewRobot.offsetX}`);
            console.log(`fieldViewRobot offsetY ${fieldViewRobot.offsetY}`);
        }
        onWidthChanged: {
            fieldView.currentWidth = Math.min(width, height);
            console.log(`currentWidth ${currentWidth}`);
        }

        PJFieldViewRobot {
            id: fieldViewRobot
            imageScale: 2

            // idk screensaver animation lmao
            SequentialAnimation on inchesX {
                loops: Animation.Infinite
                PropertyAnimation {
                    to: 72
                    duration: 1000
                    easing.type: Easing.InOutSine;
                }
                PropertyAnimation {
                    to: -72
                    duration: 900
                    easing.type: Easing.InOutSine;
                }
            }
            SequentialAnimation on inchesY{
                loops: Animation.Infinite
                PropertyAnimation {
                    to: -72
                    duration: 800
                    easing.type: Easing.InOutSine;
                }
                PropertyAnimation {
                    to: 72
                    duration: 700
                    easing.type: Easing.InOutSine;
                }
            }


            // focus: true //ENABLE if want fieldViewRobot to move

            // Keys.onPressed: {
            //     let key = event.key
            //     if(key === Qt.Key_W)
            //     {
            //         fieldViewRobot.changeY(12);
            //     }
            //     else if(key === Qt.Key_S)
            //     {
            //         fieldViewRobot.changeY(-12);
            //     }
            //     else if(key === Qt.Key_A)
            //     {
            //         fieldViewRobot.changeX(-12);
            //     }
            //     else if(key === Qt.Key_D)
            //     {
            //         fieldViewRobot.changeX(12);
            //     }
            // }
        }
    }
}
