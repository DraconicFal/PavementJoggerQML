#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QIcon>

// Imported class
#include "src/cpp/pjprojectbackend.h"
#include "src/cpp/pjprojectxmlhandler.h"
#include "src/cpp/commands/pjcommandbackend.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/Images/src/assets/PavementJoggerLogo.png"));

    QQmlApplicationEngine engine;
    PJCommandBackend::publicEngine = &engine;

    // Register singletons in the qml/global directory
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/singletons/src/qml/global/PJGlobalKeyboard.qml")), "PavementJogger", 1, 0, "PJGlobalKeyboard");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/singletons/src/qml/global/PJGlobalPalette.qml")), "PavementJogger", 1, 0, "PJGlobalPalette");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/singletons/src/qml/global/PJGlobalTimeline.qml")), "PavementJogger", 1, 0, "PJGlobalTimeline");

    /// Make the c++ classes visible to QML ///
    // XML handler
    PJProjectXmlHandler projectXmlHandler(nullptr, &engine);
    engine.rootContext()->setContextProperty("projectXmlHandler", &projectXmlHandler);

    // Project backend
    PJProjectBackend projectBackend{};
    engine.rootContext()->setContextProperty("projectBackend", &projectBackend);

    // Command backend
    PJCommandBackend commandBackend{};
    engine.rootContext()->setContextProperty("commandBackend", &commandBackend);


    const QUrl url(QStringLiteral("qrc:/PavementJogger/src/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
