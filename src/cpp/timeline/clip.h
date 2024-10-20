#ifndef CLIP_H
#define CLIP_H

#include <QObject>

class Clip {
public:
    Clip(const QString movementName, const int trackID, const int trackIndex, const int startTick, const int endTick, const int minDuration) :
        movementName(movementName),
        trackID(trackID),
        trackIndex(trackIndex),
        startTick(startTick),
        endTick(endTick),
        minDuration(minDuration) {
    }

    QString movementName;
    int trackID;
    int trackIndex;
    int startTick;
    int endTick;
    int minDuration;
};

#endif // CLIP_H
