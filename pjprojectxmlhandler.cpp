#include "pjprojectxmlhandler.h"

PJProjectXmlHandler::PJProjectXmlHandler(QObject *parent,  QString projectPath)
    : QObject{parent}
{

}

QStringList PJProjectXmlHandler::getTrackNames(QString projectPath)
{
    QFile file(projectPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Could not read file!";
        qCritical() << file.errorString();
        return QList<QString>();
    }

    QByteArray data = file.readAll();
    file.close();

    QXmlStreamReader stream(data);
    QStringList trackNames = QStringList();

    while(!stream.atEnd()) {
        QXmlStreamReader::TokenType token = stream.readNext();
        switch (token) {
        case QXmlStreamReader::Comment:
            break;
        case QXmlStreamReader::DTD:
            break;
        case QXmlStreamReader::Characters:
            break;
        case QXmlStreamReader::ProcessingInstruction:
            break;
        case QXmlStreamReader::EntityReference:
            break;
        case QXmlStreamReader::NoToken:
            break;
        case QXmlStreamReader::Invalid:
            break;
        case QXmlStreamReader::StartDocument:
            break;
        case QXmlStreamReader::EndDocument:
            break;
        case QXmlStreamReader::StartElement:
            if(stream.name().toString() == "track") {
                QString trackName = stream.attributes().value("name").toString();
                trackNames.append(trackName);
            }
            break;
        case QXmlStreamReader::EndElement:
            break;
        }
    }

    return trackNames;

}

void PJProjectXmlHandler::writeTrackNames(QString projectPath, QStringList trackNames)
{

}
