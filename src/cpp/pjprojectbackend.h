#ifndef PJPROJECTBACKEND_H
#define PJPROJECTBACKEND_H

#include <QObject>
#include <QDebug>

class PJProjectBackend : public QObject
{
    Q_OBJECT
public:
    explicit PJProjectBackend(QObject *parent = nullptr);
    static QString projectPath;

signals:

public slots:
    void setProjectPath(QString projectPath) {
        PJProjectBackend::projectPath = projectPath;
    }
    QString getProjectPath() {
        return PJProjectBackend::projectPath;
    }
};

#endif // PJPROJECTBACKEND_H
