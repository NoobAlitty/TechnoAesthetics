#pragma once

#include <QObject>
#include <QThreadPool>
#include "TaskBase.hpp"
// #include"ImageProcessor.h"

class ThreadPool : public QObject
{
    Q_OBJECT
public:
    ThreadPool(QObject *parent=nullptr) : QObject(parent){
        m_threadPool.setMaxThreadCount(8);
    }
    ~ThreadPool(){
        m_threadPool.waitForDone();
    }
    Q_INVOKABLE TaskBase* create(QString opt){
        // if(opt=="image")
        //     return new ImageProcessor();
        return nullptr;
    }
    Q_INVOKABLE void add(TaskBase* task){
        m_threadPool.start(task);
    }
private:
    QThreadPool m_threadPool;
};
