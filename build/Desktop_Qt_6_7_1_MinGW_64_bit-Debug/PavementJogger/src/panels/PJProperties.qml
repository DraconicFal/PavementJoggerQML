import QtQuick

Item {
    id: pj_properties

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
                text: qsTr("Properties")
                anchors.left: parent.left
                topPadding: 4
                leftPadding: 5
                color: "#ffffff"
            }
        }

        Column {
            id: columnProperties
            x:0
            y:0
            width: parent.width
            height: parent.height

        }
    }

}
