#include "pjcommandbackend.h"
#include "addclipcommand.h"
#include "../timeline/clip.h"

QQmlApplicationEngine *PJCommandBackend::publicEngine = nullptr;

PJCommandBackend::PJCommandBackend(QObject *parent) : QObject(parent) {}

void PJCommandBackend::addClip(QString movementName, int trackID, int trackIndex, int startTick, int endTick, int minDuration)
{
    Clip clip(movementName, trackID, trackIndex, startTick, endTick, minDuration);
    AddClipCommand *addClipCommand = new AddClipCommand(clip);
    commandManager.executeCommand(addClipCommand);
}

void PJCommandBackend::removeClip(int trackID, int trackIndex)
{

}

void PJCommandBackend::undo() {
    commandManager.undo();
}

void PJCommandBackend::redo() {
    commandManager.redo();
}

void PJCommandBackend::executeCommand(Command *command) {
    commandManager.executeCommand(command);
}
