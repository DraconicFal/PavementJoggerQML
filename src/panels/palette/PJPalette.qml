import QtQuick

Item {
    id: pj_palette

    Rectangle {
        id: background
        color: "#29282E"
        anchors.fill: parent

        Rectangle {
            id: title
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#222127"
            border.color: "#09090A"
            border.width: 1.5

            Text {
                id: titleText
                text: qsTr("Palette")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "white"
            }
        }

        Column {
            id: paletteArea
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            visible: true
        }
    }

}
