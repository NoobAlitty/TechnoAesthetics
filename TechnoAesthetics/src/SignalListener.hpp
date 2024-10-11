#pragma once

#include <QObject>
#include <QString>
#include<QDebug>
class SignalListener : public QObject
{
    Q_OBJECT
public:
    SignalListener() {}
    virtual ~SignalListener() {}
    void setSignal(const QJsonObject result){
        emit signal(result);
    }
    void setPresence(bool result){
        emit presence(result);
    }
    void setMessage(const int index,const QString content,const bool isMe){
        emit message(index,content,isMe);
    }
    void setFriendpresence(const int friendId){
        emit friendpresence(friendId);
    }

signals:
    void signal(const QJsonObject result);
    void presence(const bool result);
    void message(const int index,const QString content,const bool isMe);
    void friendpresence(const int friendId);

public slots:
    void onSignal(const QJsonObject result){
        emit signal(result);
    }
    void onPresence(const bool result){
        emit presence(result);
    }
};
