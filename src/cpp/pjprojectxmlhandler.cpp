#include "pjprojectxmlhandler.h"

// Static values
#include "pjprojectbackend.h"

PJProjectXmlHandler::PJProjectXmlHandler(QObject *parent,  QQmlApplicationEngine *engine)
    : QObject{parent}
{
    this->engine = engine;
}



/////////////////////
// PALETTE METHODS //
/////////////////////
void PJProjectXmlHandler::getPaletteFolders(bool telemetry)
{
    // Locate singletons
    QObject *globalPalette = engine->singletonInstance<QObject*>("PavementJogger", "PJGlobalPalette");
    if (!globalPalette) {
        qCritical() << "cpp: PJGlobalPalette singleton instance could not be found!";
        return;
    }
    QString projectPath = PJProjectBackend::projectPath;
    QList<QVariant> currentFolders = globalPalette->property("folders").toList();

    // Deallocate clips from heap
    for (const QVariant& folder : currentFolders) {
        QObject *folderObject = folder.value<QObject*>();
        if (!folderObject) {
            qCritical() << "cpp: Tried to clear a dangling folder pointer!";
            continue;
        }

        // Iterate through each folder to delete the movements
        QList<QVariant> movements = folderObject->property("movements").toList();
        foreach (const QVariant &movement, movements) {
            QObject *item = movement.value<QObject*>();
            if (item)
                delete item;
            else
                qCritical() << "cpp: Tried to clear a dangling pointer from getPaletteMovements()!";
        }
        delete folderObject;
    }
    globalPalette->setProperty("folders", QVariant::fromValue(QList<QQuickItem*>()));
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Deallocated all of currentClips";

    // Open file to be read
    QUrl fileUrl(projectPath);
    QString filePath = fileUrl.toLocalFile();
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "cpp: Could not read file!";
        qCritical() << file.errorString();
        return;
    }
    QByteArray data = file.readAll();
    file.close();
    QXmlStreamReader stream(data);
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Opened XML file";

    // Find parent item for folders
    if (engine->rootObjects().length()==0) {
        qCritical() << "cpp: Length of engine->rootObjects() is zero!";
        return;
    }
    QQuickItem *paletteFolders = engine->rootObjects().at(0)->findChild<QQuickItem*>("paletteFolders");
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Found paletteFolders parent item" << paletteFolders;

    // Create Folder, FolderItems, and Movement component
    QQmlComponent folderComponent(engine, QUrl(QStringLiteral("qrc:/components/src/qml/panels/palette/PJPaletteFolder.qml")));
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Created folderComponent, isError: " << folderComponent.isError();

    QQmlComponent folderItemsComponent(engine, QUrl(QStringLiteral("qrc:/components/src/qml/panels/palette/PJPaletteFolderItems.qml")));
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Created folderItemsComponent, isError: " << folderItemsComponent.isError();

    QQmlComponent movementComponent(engine, QUrl(QStringLiteral("qrc:/components/src/qml/panels/palette/PJPaletteMovement.qml")));
    if (telemetry) qInfo() << "cpp: getPaletteMovements() - Created movementComponent, isError: " << movementComponent.isError();

    // Parse through XML file
    QList<QQuickItem*> folders{};
    int folderNumber = -1;
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

            /// Start a new folder ///
            if (stream.name().toString() == "folder") {
                folderNumber++;
                QString folderName = stream.attributes().value("name").toString();

                // Create Folder item
                QObject *folderObject = folderComponent.create();
                if (!folderObject) {
                    qCritical() << "cpp: Failed to load PJPaletteFolder.qml from getPaletteMovements()!";
                    qCritical() << folderComponent.errorString();
                    return;
                }
                QQuickItem *folderItem = qobject_cast<QQuickItem*>(folderObject);
                engine->setObjectOwnership(folderItem, QQmlEngine::JavaScriptOwnership);

                // Create FolderItems item
                QObject *folderItemsObject = folderItemsComponent.create();
                if (!folderItemsObject) {
                    qCritical() << "cpp: Failed to load PJPaletteFolderItems.qml from getPaletteMovements()!";
                    qCritical() << folderItemsComponent.errorString();
                    return;
                }
                QQuickItem *folderItemsItem = qobject_cast<QQuickItem*>(folderItemsObject);
                engine->setObjectOwnership(folderItemsItem, QQmlEngine::JavaScriptOwnership);

                // Set Folder properties
                folderItem->setParentItem(paletteFolders);
                folderItem->setWidth(paletteFolders->width());
                folderItem->setProperty("trackID", folderNumber);
                folderItem->setProperty("folderName", folderName);
                folderItem->setProperty("folderItems", QVariant::fromValue(folderItemsItem));
                QObject::connect(paletteFolders, &QQuickItem::widthChanged, folderItem, [folderItem, paletteFolders]() {
                    folderItem->setWidth(paletteFolders->width());
                });

                // Set FolderItems parent
                folderItemsItem->setParentItem(folderItem);
                QObject::connect(folderItem, &QQuickItem::widthChanged, folderItemsItem, [folderItemsItem, folderItem]() {
                    folderItemsItem->setWidth(folderItem->width());
                });

                // Append to list
                folders.append(folderItem);
                if (telemetry) qInfo() << "cpp: Read folder number" << folderNumber;
                break;
            }


            /// Create new movement and append to current folder ///
            if (stream.name().toString() == "movement") {
                // Error handling
                if (folderNumber == -1) {
                    qCritical() << "cpp: Tried to read a folderless movement in getPaletteMovements()! Fix your project file!";
                    return;
                }
                QQuickItem *currentFolder = folders[folderNumber];

                // Get property data
                QString name = stream.attributes().value("name").toString();
                // TODO: States list

                if (telemetry) {
                    qInfo() << "cpp: Read new movement";
                    qInfo() << "........movementName =" << name;
                }

                // Create Movement item
                QObject *movementObject = movementComponent.create();
                if (!movementObject) {
                    qCritical() << "cpp: Failed to load PJPaletteMovement.qml from getPaletteMovements()!";
                    qCritical() << movementComponent.errorString();
                    return;
                }
                QQuickItem *movementItem = qobject_cast<QQuickItem*>(movementObject);
                engine->setObjectOwnership(movementItem, QQmlEngine::JavaScriptOwnership);

                // Set properties
                movementItem->setProperty("trackID", folderNumber);
                movementItem->setProperty("movementName", name);

                // Update Folder movements
                QList<QVariant> currentMovements = currentFolder->property("movements").toList();
                currentMovements.append(QVariant::fromValue(movementItem));
                currentFolder->setProperty("movements", QVariant::fromValue(currentMovements));

                // Attach movement to FolderItems
                QQuickItem *currentFolderItems = currentFolder->property("folderItems").value<QQuickItem*>();
                movementItem->setParentItem(currentFolderItems);
                movementItem->setWidth(currentFolderItems->width());
                QObject::connect(currentFolderItems, &QQuickItem::widthChanged, movementItem, [movementItem, currentFolderItems]() {
                    movementItem->setWidth(currentFolderItems->width());
                });
            }
            break;
        case QXmlStreamReader::EndElement:
            if (stream.name().toString() == "folder") {
                QQuickItem *currentFolder = folders[folderNumber];
                QList<QVariant> currentMovements = currentFolder->property("movements").toList();
                if (telemetry) qInfo() << "Folder num" << folderNumber << ":" << currentMovements;
            }
            break;
        }
    }

    globalPalette->setProperty("folders", QVariant::fromValue(folders));

}

void PJProjectXmlHandler::writePaletteFolders(QString projectPath, QList<QQuickItem*> folders)
{

}



//////////////////////
// TIMELINE METHODS //
//////////////////////
QStringList PJProjectXmlHandler::getTimelineTrackNames(QString projectPath)
{
    // Open file to be read
    QUrl fileUrl(projectPath);
    QString filePath = fileUrl.toLocalFile();
    QFile file(filePath);
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
    QUrl fileUrl(projectPath);
    QString filePath = fileUrl.toLocalFile();
    QFile file(filePath);
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
    QQmlComponent clipComponent(engine, QUrl(QStringLiteral("qrc:/components/src/qml/panels/timeline/PJTimelineClip.qml")));
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
