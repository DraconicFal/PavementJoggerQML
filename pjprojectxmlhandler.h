#ifndef PJPROJECTXMLHANDLER_H
#define PJPROJECTXMLHANDLER_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QXmlStreamReader>
#include <QXmlStreamWriter>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickItem>

class PJProjectXmlHandler : public QObject
{
    Q_OBJECT
public:
    explicit PJProjectXmlHandler(QObject *parent = nullptr, QQmlApplicationEngine *engine = nullptr);

private:
    QQmlApplicationEngine *engine;

signals:

public slots:
    QStringList getTrackNames(QString projectPath);
    void writeTrackNames(QString projectPath, QStringList trackNames);

    QList<QList<QQuickItem *>> getClips(QString projectPath, QList<QList<QQuickItem *>> currentClips, bool telemetry=false);
};

#endif // PJPROJECTXMLHANDLER_H
