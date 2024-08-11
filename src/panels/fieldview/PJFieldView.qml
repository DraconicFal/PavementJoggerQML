import QtQuick

Item {
    id: fieldView

    Image {
        id: testImage
        anchors.fill: parent
        source: "qrc:/Images/assets/PavementJoggerLogo.png"
        fillMode: Image.PreserveAspectFit

        FVRobot {
            id: fVRobot
            width: 100
            height: 100
            x: parent.x
            y: parent.y
            //focus: true //ENABLE if want fVRobot to move
            Keys.onPressed: {
                let key = event.key
                if(key === Qt.Key_W)
                {
                    //console.log("DOES THIS WORK")
                    fVRobot.move(-15, "vertical")
                }
                else if(key === Qt.Key_S)
                {
                    fVRobot.move(15, "vertical")
                }
                else if(key === Qt.Key_A)
                {
                    fVRobot.move(-15, "horizontal")
                }
                else if(key === Qt.Key_D)
                {
                    fVRobot.move(15, "horizontal")
                }
            }
        }
    }
}
