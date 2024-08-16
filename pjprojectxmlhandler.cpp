#include "pjprojectxmlhandler.h"

PJProjectXmlHandler::PJProjectXmlHandler(QObject *parent,  QQmlApplicationEngine *engine)
    : QObject{parent}
{
    this->engine = engine;
}



/////////////////////
// PALETTE METHODS //
/////////////////////
QList<QList<QQuickItem*>> PJProjectXmlHandler::getPaletteMovements(QString projectPath, QList<QList<QQuickItem*>> currentMovements)
{
    // Open file to be read
    QFile file(projectPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "cpp: Could not read file!";
        qCritical() << file.errorString();
        return QList<QList<QQuickItem*>>();
    }
    QByteArray data = file.readAll();
    file.close();
    QXmlStreamReader stream(data);

    // Parse through file
    // TODO
    return QList<QList<QQuickItem*>>();

}

void PJProjectXmlHandler::writePaletteMovements(QString projectPath, QList<QList<QQuickItem*>> movements)
{

}



//////////////////////
// TIMELINE METHODS //
//////////////////////
QStringList PJProjectXmlHandler::getTimelineTrackNames(QString projectPath)
{
    // Open file to be read
    QFile file(projectPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "cpp: Could not read file!";
        qCritical() << file.errorString();
        return QList<QString>();
    }
    QByteArray data = file.readAll();
    file.close();
    QXmlStreamReader stream(data);

    // Parse through file
    QStringList trackNames = QStringList();
    while(!stream.atEnd()) {
        QXmlStreamReader::TokenType token = stream.readNext();
        switch (token) {
        case QXmlStreamReader::Comment:
            break;
        case QXmlStreamReader::DTD:
            break;
        case QXmlStreamReader::Characters:
            break;
        case QXmlStreamReader::ProcessingInstruction:
            break;
        case QXmlStreamReader::EntityReference:
            break;
        case QXmlStreamReader::NoToken:
            break;
        case QXmlStreamReader::Invalid:
            break;
        case QXmlStreamReader::StartDocument:
            break;
        case QXmlStreamReader::EndDocument:
            break;
        case QXmlStreamReader::StartElement:
            if(stream.name().toString() == "track") {
                QString trackName = stream.attributes().value("name").toString();
                trackNames.append(trackName);
            }
            break;
        case QXmlStreamReader::EndElement:
            break;
        }
    }

    return trackNames;

}

void PJProjectXmlHandler::writeTimelineTrackNames(QString projectPath, QStringList trackNames)
{

}

QList<QList<QQuickItem*>> PJProjectXmlHandler::getTimelineClips(QString projectPath, QList<QList<QQuickItem*>> currentClips, bool telemetry)
{
    // Deallocate clips from heap
    for (QList<QQuickItem*> &itemList : currentClips) {
        for (QQuickItem *item : itemList) {
            if (item)
                delete item;
            else
                qCritical() << "cpp: Tried to clear a dangling pointer from getTimelineClips()!";
        }
    }
    if (telemetry) qInfo() << "cpp: getTimelineClips() - Deallocated all of currentClips";

    // Open file to be read
    QFile file(projectPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "cpp: Could not read file!";
        qCritical() << file.errorString();
        return QList<QList<QQuickItem*>>();
    }
    QByteArray data = file.readAll();
    file.close();
    QXmlStreamReader stream(data);
    if (telemetry) qInfo() << "cpp: getTimelineClips() - Opened XML file";

    // Find parent item for clips
    if (engine->rootObjects().length()==0) {
        qCritical() << "cpp: Length of engine->rootObjects() is zero!";
        return QList<QList<QQuickItem*>>();
    }
    QQuickItem *timelineTracks = engine->rootObjects().at(0)->findChild<QQuickItem*>("timelineTracks");
    if (telemetry) qInfo() << "cpp: getTimelineClips() - Found timelineTracks parent item" << timelineTracks;

    // Create clip component
    QQmlComponent clipComponent(engine, QUrl(QStringLiteral("qrc:/components/src/panels/timeline/PJTimelineClip.qml")));
    if (telemetry) qInfo() << "cpp: getTimelineClips() - Created clipComponent, isError: " << clipComponent.isError();

    // Parse through XML file
    QList<QList<QQuickItem*>> clips{};
    int trackNumber = -1;
    int clipCount = 0;
    while(!stream.atEnd()) {
        QXmlStreamReader::TokenType token = stream.readNext();
        switch (token) {
        case QXmlStreamReader::Comment:
            break;
        case QXmlStreamReader::DTD:
            break;
        case QXmlStreamReader::Characters:
            break;
        case QXmlStreamReader::ProcessingInstruction:
            break;
        case QXmlStreamReader::EntityReference:
            break;
        case QXmlStreamReader::NoToken:
            break;
        case QXmlStreamReader::Invalid:
            break;
        case QXmlStreamReader::StartDocument:
            break;
        case QXmlStreamReader::EndDocument:
            break;
        case QXmlStreamReader::StartElement:

            // Add a new track
            if (stream.name().toString() == "track") {
                trackNumber++;
                clips.append(QList<QQuickItem*>());
                if (telemetry) qInfo() << "cpp: Read track number" << trackNumber;
                break;
            }

            // Create new clip and append to clips list
            if (stream.name().toString() == "clip") {
                // Error handling
                if (trackNumber == -1) {
                    qCritical() << "cpp: Tried to read a trackless clip in getTimelineClips()! Fix your project file!";
                    return QList<QList<QQuickItem*>>();
                }

                // Get property data
                QString movementName = stream.attributes().value("movementName").toString();
                int startTick = stream.attributes().value("startTick").toInt();
                int endTick = stream.attributes().value("endTick").toInt();
                double minDuration = stream.attributes().value("minDuration").toDouble();

                if (telemetry) {
                    qInfo() << "cpp: Read new clip";
                    qInfo() << "........movementName =" << movementName;
                    qInfo() << "........startTick =" << startTick;
                    qInfo() << "........endTick =" << endTick;
                    qInfo() << "........minDuration =" << minDuration;
                }

                // Create clip and append
                QObject *clipObject = clipComponent.create();
                if (clipObject) {
                    clipCount++;
                    QQuickItem *clipItem = qobject_cast<QQuickItem*>(clipObject);
                    engine->setObjectOwnership(clipItem, QQmlEngine::JavaScriptOwnership);
                    clipItem->setParentItem(timelineTracks);
                    clipItem->setProperty("movementName", movementName);
                    clipItem->setProperty("trackID", trackNumber);
                    clipItem->setProperty("trackIndex", clips[trackNumber].length());
                    clipItem->setProperty("startTick", startTick);
                    clipItem->setProperty("endTick", endTick);
                    clipItem->setProperty("minDuration", minDuration);
                    clipItem->setProperty("z", clipCount);
                    clips[trackNumber].append(clipItem);
                }
                else {
                    qCritical() << "cpp: Failed to load PJClip.qml from getTimelineClips()!";
                    qCritical() << clipComponent.errorString();
                }

            }
            break;
        case QXmlStreamReader::EndElement:
            break;
        }
    }

    return clips;

}

void PJProjectXmlHandler::writeTimelineClips(QString projectPath, QList<QList<QQuickItem*>> clips)
{

}
