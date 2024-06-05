import QtQuick
import QtQuick.Controls

MenuBar {
    id: pj_menuBar

    Menu {
        id: fileMenu
        title: "File"
        MenuItem {text: "New"}
        MenuItem {text: "Open"}
        MenuSeparator {}
        MenuItem {text: "Save"}
        MenuItem {text: "Save As..."}
    }
}
