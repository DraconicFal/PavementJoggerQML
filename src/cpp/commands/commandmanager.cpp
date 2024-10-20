#include "CommandManager.h"

void CommandManager::executeCommand(Command *command) {
    command->execute();
    undoStack.push_back(command);

    // Properly clear Redo stack
    for (Command *command : redoStack) {
        delete command;
    }
    redoStack.clear();
}

void CommandManager::undo() {
    if (!undoStack.empty()) {
        Command *command = undoStack.back();
        command->undo();
        undoStack.pop_back();
        redoStack.push_back(command);
    }
}

void CommandManager::redo() {
    if (!redoStack.empty()) {
        Command *command = redoStack.back();
        command->execute();
        redoStack.pop_back();
        undoStack.push_back(command);
    }
}
