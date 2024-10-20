cmake_minimum_required(VERSION 3.16)

project(PavementJogger VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appPavementJogger
    src/main.cpp
)

set(cpp_files
    ## Project backend ##
    src/cpp/pjprojectbackend.h src/cpp/pjprojectbackend.cpp
    src/cpp/pjprojectxmlhandler.h src/cpp/pjprojectxmlhandler.cpp

    # Timeline
    src/cpp/timeline/clip.h

    ## Command system ##
    src/cpp/commands/pjcommandbackend.h src/cpp/commands/pjcommandbackend.cpp
    src/cpp/commands/commandmanager.h src/cpp/commands/commandmanager.cpp
    src/cpp/commands/addclipcommand.h src/cpp/commands/addclipcommand.cpp
    src/cpp/commands/command.h
)

set(plain_qml_files
    src/Main.qml
    src/qml/PJKeybindHandler.qml

    #-# Panels #-#

    ## Menu Bar files ##
    src/qml/panels/menubar/PJMenuBar.qml
    src/qml/panels/menubar/PJMenuBarSeparator.qml

    ## Field View panel files ##
    src/qml/panels/fieldview/PJFieldView.qml
    src/qml/panels/fieldview/PJFieldViewRobot.qml

    ## Palette panel files ##
    src/qml/panels/palette/PJPalette.qml
    src/qml/panels/palette/PJPaletteGhostItem.qml
    src/qml/panels/palette/PJPaletteFolder.qml
    src/qml/panels/palette/PJPaletteFolderItems.qml
    src/qml/panels/palette/PJPaletteMovement.qml

    ## Properties panel files ##
    src/qml/panels/properties/PJProperties.qml

    ## Timeline panel files ##
    src/qml/panels/timeline/PJTimeline.qml
    src/qml/panels/timeline/PJTimelineClip.qml
    src/qml/panels/timeline/PJTimelineZoomSlider.qml
    src/qml/panels/timeline/PJTimelineScrollArea.qml
    # Labels
    src/qml/panels/timeline/labels/PJTimelineLabels.qml
    src/qml/panels/timeline/labels/PJTimelineScrubberLabel.qml
    src/qml/panels/timeline/labels/PJTimelineTrackLabels.qml
    # Content
    src/qml/panels/timeline/content/PJTimelineContent.qml
    src/qml/panels/timeline/content/PJTimelineRuler.qml
    src/qml/panels/timeline/content/PJTimelineScrubber.qml
    src/qml/panels/timeline/content/PJTimelineTracks.qml
    src/qml/panels/timeline/content/PJTimelineShadowItem.qml

)

set(qml_singletons
    ## System ##
    src/qml/global/PJGlobalKeyboard.qml

    ## Panels ##
    src/qml/global/PJGlobalPalette.qml
    src/qml/global/PJGlobalTimeline.qml
)

set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appPavementJogger
    URI PavementJogger
    VERSION 1.0
    RESOURCES QTL.qrc
    SOURCES ${cpp_files}
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
