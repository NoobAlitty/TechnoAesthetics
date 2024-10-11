#pragma once

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QVariant>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <memory>
#include"FileManager.h"

class NetworkManager : public QObject
{
    Q_OBJECT

public:
    explicit NetworkManager(QObject* parent = nullptr);
    ~NetworkManager();

    Q_INVOKABLE void get(const QString& url);
    Q_INVOKABLE void post(const QString& url, const QJsonObject& data);

signals:
    void requestFinished(const QJsonObject& response);
    void error(QString errorString);

private slots:
    void onRequestFinished(QNetworkReply* reply);
    void onError(QNetworkReply::NetworkError error);

private:
    void setAuthorizationHeader(QNetworkRequest& request);

private:
    std::unique_ptr<QNetworkAccessManager> m_networkManager_;
    static const QString BASE_URL;
    FileManager fileManager;
};
