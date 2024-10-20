#ifndef PJCOMMANDBACKEND_H
#define PJCOMMANDBACKEND_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "commandmanager.h"

class PJCommandBackend : public QObject {
    Q_OBJECT
    CommandManager commandManager;

public:
    explicit PJCommandBackend(QObject *parent = nullptr);

    static QQmlApplicationEngine *publicEngine;

    void executeCommand(Command *command);

public slots:
    void addClip(QString movementName, int trackID, int trackIndex, int startTick, int endTick, int minDuration);
    void removeClip(int trackID, int trackIndex);

    void undo();
    void redo();

};

#endif // PJCOMMANDBACKEND_H
