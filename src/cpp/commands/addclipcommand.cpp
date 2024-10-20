#include "addclipcommand.h"
#include "pjcommandbackend.h"

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickItem>

static QQmlApplicationEngine *engine = PJCommandBackend::publicEngine;

AddClipCommand::AddClipCommand(const Clip &clip)
    : clip(clip) {}


void AddClipCommand::execute() {
    // Locate singletons
    QObject *globalTimeline = engine->singletonInstance<QObject*>("PavementJogger", "PJGlobalTimeline");
    if (!globalTimeline) {
        qCritical() << "cpp: PJGlobalTimeline singleton instance could not be found in AddClipCommand::execute()!";
        return;
    }

    // Create Clip component
    QQmlComponent clipComponent(engine, QUrl(QStringLiteral("qrc:/components/src/qml/panels/timeline/PJTimelineClip.qml")));
    if (clipComponent.isError()) {
        qCritical() << "cpp: Could not create clipComponent in AddClipCommand::execute()!";
        return;
    }

    // Find parent item for clips
    if (engine->rootObjects().length()==0) {
        qCritical() << "cpp: Length of engine->rootObjects() is zero!";
        return;
    }
    QQuickItem *timelineTracks = engine->rootObjects().at(0)->findChild<QQuickItem*>("timelineTracks");

    // Create Clip item
    QVariantMap initialProperties;
    initialProperties.insert("movementName", clip.movementName);
    initialProperties.insert("trackID", clip.trackID);
    initialProperties.insert("trackIndex", clip.trackIndex);
    initialProperties.insert("startTick", clip.startTick);
    initialProperties.insert("endTick", clip.endTick);
    initialProperties.insert("minDuration", clip.minDuration);
    QObject *clipObject = clipComponent.createWithInitialProperties(initialProperties);
    if (!clipObject) {
        qCritical() << "cpp: Failed to load PJTimelineClip.qml from AddClipCommand::execute()!";
        qCritical() << clipComponent.errorString();
        return;
    }
    QQuickItem *clipItem = qobject_cast<QQuickItem*>(clipObject);
    clipItem->setParentItem(timelineTracks);
    engine->setObjectOwnership(clipItem, QQmlEngine::JavaScriptOwnership);

    // Insert Clip item into newClips array
    QList<QVariant> clips = globalTimeline->property("clips").toList();
    QList<QList<QVariant>> newClips{};
    for (int track=0; track<clips.length(); track++) {
        newClips.append(clips[track].value<QList<QVariant>>());
    }
    newClips[clip.trackID].insert(clip.trackIndex, QVariant::fromValue(clipItem));

    // Replace and update array
    globalTimeline->setProperty("clips", QVariant::fromValue(newClips));
}


void AddClipCommand::undo() {
    // Locate singletons
    QObject *globalTimeline = engine->singletonInstance<QObject*>("PavementJogger", "PJGlobalTimeline");
    if (!globalTimeline) {
        qCritical() << "cpp: PJGlobalTimeline singleton instance could not be found in AddClipCommand::execute()!";
        return;
    }

    // Filter out the Clip into newClips array
    QList<QVariant> clips = globalTimeline->property("clips").toList();
    QList<QList<QVariant>> newClips{};
    for (int track=0; track<clips.length(); track++) {
        newClips.append(clips[track].value<QList<QVariant>>());
    }
    newClips[clip.trackID].remove(clip.trackID);

    // Replace and update array
    globalTimeline->setProperty("clips", QVariant::fromValue(newClips));
}
