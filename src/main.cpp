#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQmlContext>

// Imported class
#include "pjprojectxmlhandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/Images/assets/PavementJoggerLogo.png"));

    QQmlApplicationEngine engine;

    // Add PJProjectXmlHandler to PJGlobalProject
    PJProjectXmlHandler projectXmlHandler;
    engine.rootContext()->setContextProperty("projectXmlHandler", &projectXmlHandler);

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
