#pragma once

#include <QObject>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QWebSocket>
#include <QDebug>
#include<QTimer>
#include"FileManager.h"
#include"SignalListener.hpp"
#include"NetworkManager.h"

class ChatClient : public QObject
{
    Q_OBJECT

public:
    ChatClient(QObject* parent = nullptr) : QObject(parent)
    {
        m_webSocket = new QWebSocket();
        userInfoNet=new NetworkManager();
        // friendInfoNet=new NetworkManager();
        messageNet=new NetworkManager();
        fileManager.init();
        // 连接信号槽
        connect(m_webSocket, &QWebSocket::connected, this, &ChatClient::onConnected);
        connect(m_webSocket, &QWebSocket::disconnected, this, &ChatClient::onDisconnected);
        connect(m_webSocket, &QWebSocket::textMessageReceived, this, &ChatClient::onMessageReceived);

        connect(messageNet,&NetworkManager::requestFinished,this,&ChatClient::onAllMessageReceived);
    }

    ~ChatClient()
    {
        m_webSocket->close();
        delete m_webSocket;
        delete userInfoNet;
        delete messageNet;
    }

    Q_INVOKABLE void connectToServer()
    {
        // // 设置附加头信息，将令牌作为连接请求的一部分发送到服务器
        QNetworkRequest request(getUrl());
        request.setRawHeader("Authorization", ("Bearer " + fileManager.read("token","string").toString()).toUtf8());
        m_webSocket->open(request);
        qDebug()<<"Trying to connect to the WebSocket......";
    }

    Q_INVOKABLE void sendPrivateMessage(const int& recipient, const QString& message,const QString& format)
    {
        m_webSocket->sendTextMessage(makeText("private",message,recipient,format));
        userSig->setMessage(friendIdToIndex[recipient],message,true);
    }

    Q_INVOKABLE void sendGroupMessage(const int& group, const QString& message,const QString& format)
    {
        m_webSocket->sendTextMessage(makeText("group",message,group,format));
        userSig->setMessage(groupIdToIndex[group],message,true);
    }

    Q_INVOKABLE void sendAiMessage(const int& ai, const QString& message,const QString& format)
    {
        m_webSocket->sendTextMessage(makeText("ai",message,ai,format));
    }

    Q_INVOKABLE void bind(QString type,int id,SignalListener*sig){
        if(type=="private"){
            friendIdToIndex.insert(id,currentIndex++);
            friendIdToSig.insert(id,sig);
        }
        else if(type=="group"){
            groupIdToIndex.insert(id,currentIndex++);
            groupIdToSig.insert(id,sig);
        }
        else if(type=="ai"){
            aiIdToIndex.insert(id,0);
            aiIdToSig.insert(id,sig);
        }
    }
    Q_INVOKABLE int getIndex(QString type,int id){
        if(type=="private")
            return friendIdToIndex[id];
        else if(type=="group")
            return groupIdToIndex[id];
        else if(type=="ai")
            return aiIdToIndex[id];
        return 0;
    }
    Q_INVOKABLE void userSigBind(SignalListener* sig){
        userSig=sig;
        connect(userInfoNet,&NetworkManager::requestFinished,userSig,&SignalListener::onSignal);
    }
    Q_INVOKABLE void refreshUserInfo(){
        userInfoNet->get("my/getUserInfo");
    }
    Q_INVOKABLE void refreshMessage(){
        messageNet->get("my/getMessage");
    }
    Q_INVOKABLE bool reStart(){
        currentIndex=0;
        friendIdToSig.clear();
        groupIdToSig.clear();
        friendIdToIndex.clear();
        groupIdToIndex.clear();
        if(m_webSocket->state()==QAbstractSocket::UnconnectedState){
            connectToServer();
            return true;
        }
        else return false;
    }
    QString makeText(const QString& type,const QString& message,const int& to,const QString& format){
        QJsonObject json;
        json["type"] = type;
        json["receiver"] = to;
        json["content"] = message;
        json["format"] = format;
        json["time"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODate);
        return QString::fromStdString(QJsonDocument(json).toJson().toStdString());
    }

    QUrl getUrl(){
        return "ws://139.199.225.175:8080/websocket?token="+fileManager.read("token","string").toString();
        // return "ws://127.0.0.1:8080/websocket?token="+fileManager.read("token","string").toString();
    }
private slots:
    void onConnected()
    {
        qDebug() << "Connected to WebSocket server";
        if(userSig)
            userSig->setPresence(true);
    }

    void onDisconnected()
    {
        qDebug() << "Disconnected from WebSocket server";
        if(userSig)
            userSig->setPresence(false);
    }

    void onMessageReceived(const QString& message)
    {
        QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
        QJsonObject json = doc.object();
        if(json["type"].toString()=="private"){
            int senderId = json["sender"].toInt();
            if(friendIdToSig.contains(senderId)){
                friendIdToSig[senderId]->setSignal(json);
                userSig->setMessage(friendIdToIndex[senderId],json["content"].toString(),false);
            }
        }
        else if(json["type"].toString()=="group"){
            int groupId = json["receiver"].toInt();
            if(groupIdToSig.contains(groupId)){
                groupIdToSig[groupId]->setSignal(json);
                userSig->setMessage(groupIdToIndex[groupId],json["content"].toString(),false);
            }
        }
        else if(json["type"].toString()=="ai"){
            int aiId = json["sender"].toInt();
            if(aiIdToSig.contains(aiId)){
                aiIdToSig[aiId]->setSignal(json);
            }
        }
        else if(json["type"].toString()=="online"){
            int userId = json["id"].toInt();
            if(friendIdToSig.contains(userId)){
                friendIdToSig[userId]->setFriendpresence(userId);
                userSig->setFriendpresence(userId);
            }
        }

    }
    void onAllMessageReceived(const QJsonObject& response){
        if(response["status"]==200){
            for (const QJsonValue& json : response["data"].toArray()){
                int senderId = json.toObject()["sender"].toInt();
                int receiverId=json.toObject()["receiver"].toInt();
                if(json.toObject()["type"].toString()=="private"){
                    if(friendIdToSig.contains(senderId))
                        friendIdToSig[senderId]->setSignal(json.toObject());
                    else if(friendIdToSig.contains(receiverId))
                        friendIdToSig[receiverId]->setSignal(json.toObject());
                }
                else if(json.toObject()["type"].toString()=="group"){
                    if(groupIdToSig.contains(receiverId))
                        groupIdToSig[receiverId]->setSignal(json.toObject());
                }
                else if(json.toObject()["type"].toString()=="ai"){
                    if(aiIdToSig.contains(receiverId)){
                        aiIdToSig[receiverId]->setSignal(json.toObject());
                    }
                    else if(aiIdToSig.contains(senderId)){
                        aiIdToSig[senderId]->setSignal(json.toObject());
                    }
                }
            }
        }
    }

private:
    FileManager fileManager;
    QWebSocket* m_webSocket;
    QHash<int, SignalListener*> friendIdToSig;//id到SignalListener的映射
    QHash<int, SignalListener*> groupIdToSig;//id到SignalListener的映射
    QHash<int, SignalListener*> aiIdToSig;//id到SignalListener的映射
    QHash<int,int>friendIdToIndex;//id到index的映射
    QHash<int,int>groupIdToIndex;//id到index的映射
    QHash<int,int>aiIdToIndex;//id到index的映射
    NetworkManager* userInfoNet;
    NetworkManager* messageNet;
    SignalListener*userSig;
    int currentIndex=0;
};
