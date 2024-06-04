cmake_minimum_required(VERSION 3.16)

project(PavementJogger VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appPavementJogger
    src/main.cpp
)

set(plain_qml_files
    src/Main.qml
    src/panels/menubar/PJMenuBar.qml
    src/panels/fieldview/PJFieldView.qml
    src/panels/palette/PJPalette.qml
    src/panels/properties/PJProperties.qml

    src/panels/timeline/PJTimeline.qml
    src/panels/timeline/PJTimelineLabels.qml
    src/panels/timeline/PJTimelineRuler.qml
    src/panels/timeline/PJTimelineTracks.qml
    src/panels/timeline/PJTimelineScrubber.qml
)

set(qml_singletons
    src/global/PJGlobalTimeline.qml
)

set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appPavementJogger
    URI PavementJogger
    VERSION 1.0
    RESOURCES QTL.qrc
    QML_FILES ${plain_qml_files} ${qml_singletons}
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
    PRIVATE
        Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appPavementJogger
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
