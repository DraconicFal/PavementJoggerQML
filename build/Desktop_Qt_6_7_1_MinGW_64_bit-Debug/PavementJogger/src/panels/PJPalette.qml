import QtQuick

Item {
    id: pj_palette

    Rectangle {
        id: background
        color: "#3d3d3d"
        anchors.fill: parent

        Rectangle {
            id: title
            anchors.top: parent.top
            width: parent.width
            height: 25
            color: "#242424"

            Text {
                id: titleText
                text: qsTr("Palette")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "#ffffff"
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
