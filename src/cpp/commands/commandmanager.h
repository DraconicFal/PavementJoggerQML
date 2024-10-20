#ifndef COMMANDMANAGER_H
#define COMMANDMANAGER_H

#include <vector>
#include "command.h"

class CommandManager {
    std::vector<Command*> undoStack;
    std::vector<Command*> redoStack;

public:
    void executeCommand(Command *command);
    void undo();
    void redo();
};

#endif // COMMANDMANAGER_H
