#ifndef ADDCLIPCOMMAND_H
#define ADDCLIPCOMMAND_H

#include "command.h"
#include "src/cpp/timeline/clip.h"


class AddClipCommand : public Command {
    Clip clip;
public:
    AddClipCommand(const Clip &clip);

    void execute() override;
    void undo() override;
};

#endif // ADDCLIPCOMMAND_H
