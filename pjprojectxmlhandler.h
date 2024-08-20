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
    /// Palette Methods ///
    QList<QQuickItem*> getPaletteFolders(QString projectPath, QList<QQuickItem*> currentFolders, bool telemetry=false);
    void writePaletteFolders(QString projectPath, QList<QQuickItem*> folders);

    /// Timeline Methods ///
    QStringList getTimelineTrackNames(QString projectPath);
    void writeTimelineTrackNames(QString projectPath, QStringList trackNames);

    QList<QList<QQuickItem*>> getTimelineClips(QString projectPath, QList<QList<QQuickItem*>> currentClips, bool telemetry=false);
    void writeTimelineClips(QString projectPath, QList<QList<QQuickItem*>> clips);
};

#endif // PJPROJECTXMLHANDLER_H
