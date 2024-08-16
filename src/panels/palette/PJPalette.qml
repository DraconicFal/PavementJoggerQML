import QtQuick

Item {
    id: palette

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#29282E"

        /// TITLE ///
        Rectangle {
            id: title
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 25

            /// VISUAL ///
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

        /// FOLDERS ///
        Column {
            id: folders
            objectName: "paletteFolders"
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom


            //TODO: TEST FOLDERS REMOVE LATER
            PJPaletteFolder {
                trackID: 0
                subsystemName: "Translation"
                movementCount: 2

                folderItems: PJPaletteFolderItems {
                    PJPaletteMovement {
                        trackID: 0
                        movementName: "LinearTranslation"
                    }

                    PJPaletteMovement {
                        trackID: 0
                        movementName: "CRSplineTranslation"
                    }
                }
            }


            PJPaletteFolder {
                trackID: 1
                subsystemName: "Rotation"
                movementCount: 1

                folderItems: PJPaletteFolderItems {
                    PJPaletteMovement {
                        trackID: 1
                        movementName: "LinearRotation"
                    }
                }
            }


            PJPaletteFolder {
                trackID: 2
                subsystemName: "Lift"
                movementCount: 1

                folderItems: PJPaletteFolderItems {
                    PJPaletteMovement {
                        trackID: 2
                        movementName: "LinearLift"
                    }
                }
            }


        }

    }

}
