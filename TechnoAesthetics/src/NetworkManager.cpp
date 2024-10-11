#include "NetworkManager.h"

const QString NetworkManager::BASE_URL = "";
// const QString NetworkManager::BASE_URL = "http://127.0.0.1:8080/";

NetworkManager::NetworkManager(QObject* parent)
    : QObject(parent), m_networkManager_(new QNetworkAccessManager())
{
    fileManager.init();
    connect(m_networkManager_.get(), &QNetworkAccessManager::finished, this, &NetworkManager::onRequestFinished);
}

NetworkManager::~NetworkManager()
{
    // 确保资源被正确释放
}

void NetworkManager::get(const QString& url)
{
    // try {
        QNetworkRequest request((QUrl(BASE_URL+url)));
        setAuthorizationHeader(request);
        QNetworkReply* reply = m_networkManager_->get(request);
        connect(reply, &QNetworkReply::errorOccurred, this, &NetworkManager::onError);
    // } catch (const std::exception& e) {
    //     emit error(QNetworkReply::UnknownNetworkError, e.what());
    // }
}

void NetworkManager::post(const QString& url, const QJsonObject& data)
{
    // try {
        QNetworkRequest request((QUrl(BASE_URL+url)));
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        setAuthorizationHeader(request);
        QByteArray postData = QJsonDocument(data).toJson();
        QNetworkReply* reply = m_networkManager_->post(request, postData);
        connect(reply, &QNetworkReply::errorOccurred, this, &NetworkManager::onError);
    // } catch (const std::exception& e) {
    //     qDebug()<<"catch post";
    //     emit error(QNetworkReply::UnknownNetworkError, e.what());
    // }
}

void NetworkManager::onRequestFinished(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        // 获取响应状态码
        // int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        // 获取响应数据
        QByteArray responseData = reply->readAll();

        // 解析响应数据
        QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
        QJsonObject jsonObj = jsonDoc.object();

        // 发送信号
        emit requestFinished(jsonObj);
    } /*else {
        // 发送错误信号
        emit error(reply->error(), reply->errorString());
    }*/

    reply->deleteLater();
}

void NetworkManager::onError(QNetworkReply::NetworkError errorCode)
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    // int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    QByteArray responseData = reply->readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
    QJsonObject jsonObj = jsonDoc.object();

    // 处理 JSON 数据
    QString message = jsonObj["message"].toString();
    emit error(message.isEmpty()?"Network connecting error!":message);
}

void NetworkManager::setAuthorizationHeader(QNetworkRequest& request)
{
    request.setRawHeader("Authorization", QString("Bearer %1").arg(fileManager.read("token","string").toString()).toUtf8());
}
