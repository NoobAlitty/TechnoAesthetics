#pragma once

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include<QFile>
#include "FileManager.h"
#include"SignalListener.hpp"

class SpeechSynthesis : public QObject {
    Q_OBJECT

public:
    SpeechSynthesis(QObject* parent = nullptr) : QObject(parent), manager(new QNetworkAccessManager(this)) {
        connect(manager, &QNetworkAccessManager::finished, this, &SpeechSynthesis::handleResponse);
        fileManager.init();
    }

    Q_INVOKABLE void setSignal(SignalListener *sig){
        qDebug()<<"connect successfully!";
        connect(this,&SpeechSynthesis::speechFinished,sig,&SignalListener::onPresence);
    }
    Q_INVOKABLE void playSpeech(const QString& q, const QString& voiceName) {
        QJsonObject jsonData;
        jsonData["q"] = q;
        jsonData["voiceName"] = voiceName;
        QJsonDocument jsonDoc(jsonData);
        manager->post(newRequest(), jsonDoc.toJson());
    }
signals:
    void speechFinished(const bool result);
private slots:
    void handleResponse(QNetworkReply* reply) {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug()<<"获取语音数据正常！";
            QVariant contentTypeVar = reply->header(QNetworkRequest::ContentTypeHeader);
            QVariant contentDispositionVar = reply->header(QNetworkRequest::ContentDispositionHeader);

            if (contentTypeVar.toString() == "application/octet-stream" &&
                contentDispositionVar.toString().startsWith("attachment; filename=")) {
                QByteArray mp3Data = reply->readAll();
                // 保存到本地文件
                QString localFilePath = saveToLocalFile(mp3Data);
                if (!localFilePath.isEmpty()) {
                    emit speechFinished(true);
                } else {
                    qDebug() << "Failed to save audio data to local file";
                }
            } else {
                qDebug() << "Unexpected response from server";
            }
        } else {
            qDebug() << "Error getting speech:" << reply->errorString();
        }

        reply->deleteLater();
    }

private:
    QNetworkAccessManager* manager;
    FileManager fileManager;
    QNetworkRequest newRequest() {
        QNetworkRequest request(QUrl("http://139.199.225.175:8080/my/getSpeech"));
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setRawHeader("Authorization", QString("Bearer %1").arg(fileManager.read("token","string").toString()).toUtf8());
        return request;
    }
    QString saveToLocalFile(const QByteArray& audioData) {
        // 自定义保存路径
        QString localFilePath = fileManager._cachePath+"speech.mp3";

        QFile localFile(localFilePath);
        if (localFile.open(QIODevice::WriteOnly)) {
            localFile.write(audioData);
            localFile.flush();
            localFile.close();
            return localFilePath;
        } else {
            qDebug() << "Failed to open local file for writing:" << localFile.errorString();
            return QString();
        }
    }
};
