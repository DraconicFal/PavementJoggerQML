cmake_minimum_required(VERSION 3.16)

project(PavementJogger VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appPavementJogger
    src/main.cpp
)

qt_add_qml_module(appPavementJogger
    URI PavementJogger
    VERSION 1.0
    QML_FILES
        src/Main.qml
        RESOURCES assets/QTL.qrc
        QML_FILES src/panels/PJMenuBar.qml
        QML_FILES src/panels/PJFieldView.qml
        QML_FILES src/panels/PJPalette.qml
        QML_FILES src/panels/PJProperties.qml
        QML_FILES src/panels/PJTimeline.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPavementJogger PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPavementJogger4
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPavementJogger
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appPavementJogger
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
