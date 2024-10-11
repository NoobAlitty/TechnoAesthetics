#pragma once

#include <QObject>
#include <QRunnable>
#include<QMessageBox>

class TaskBase : public QObject, public QRunnable
{
    Q_OBJECT
public:
    TaskBase(QObject* parent = nullptr) : QObject(parent) {}
    virtual ~TaskBase() {}
    virtual void run() = 0;
signals:
    void taskFinished(const QJsonObject& result);
};
