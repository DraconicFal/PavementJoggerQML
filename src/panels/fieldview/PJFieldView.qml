import QtQuick

Item {
    id: fieldView
    property var imageAspectRatio;

    Image {
        id: testImage
        anchors.fill: parent
        source: "qrc:/Images/assets/PavementJoggerLogo.png"
        fillMode: Image.PreserveAspectFit

        onHeightChanged: {
            imageAspectRatio = width / height
            fVRobot.changeParameters()
        }
        onWidthChanged: {
            imageAspectRatio = width / height
            fVRobot.changeParameters()
        }

        FVRobot {
            id: fVRobot
            width: 50 / imageAspectRatio
            height: 50 / imageAspectRatio
            x: parent.x
            y: parent.y
            //focus: true //ENABLE if want fVRobot to move

            function changeParameters() {
                fVRobot.width = 50 / imageAspectRatio
                fVRobot.height = 50 / imageAspectRatio
                fVRobot.x = parent.x
                fVRobot.y = parent.y
                console.log(imageAspectRatio)
            }

            Keys.onPressed: {
                let key = event.key
                if(key === Qt.Key_W)
                {
                    //console.log("DOES THIS WORK")
                    fVRobot.move(-15 / imageAspectRatio, "vertical")
                }
                else if(key === Qt.Key_S)
                {
                    fVRobot.move(15 / imageAspectRatio, "vertical")
                }
                else if(key === Qt.Key_A)
                {
                    fVRobot.move(-15 / imageAspectRatio, "horizontal")
                }
                else if(key === Qt.Key_D)
                {
                    fVRobot.move(15 / imageAspectRatio, "horizontal")
                }
            }
        }
    }
}
