#ifndef PJPROJECTXMLHANDLER_H
#define PJPROJECTXMLHANDLER_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QXmlStreamReader>
#include <QXmlStreamWriter>

class PJProjectXmlHandler : public QObject
{
    Q_OBJECT
public:
    explicit PJProjectXmlHandler(QObject *parent = nullptr, QString projectPath = nullptr);

private:

signals:

public slots:
    QStringList getTrackNames(QString projectPath);
    void writeTrackNames(QString projectPath, QStringList trackNames);
};

#endif // PJPROJECTXMLHANDLER_H
