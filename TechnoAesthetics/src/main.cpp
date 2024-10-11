// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>  // 引入QIcon头文件
#include <QQmlContext>  // 添加这一行

#include "app_environment.h"
#include "import_qml_components_plugins.h"
#include "import_qml_plugins.h"
#include"FileManager.h"
#include"ThreadPool.hpp"
#include "NetworkManager.h"
#include"ImageProcessor.h"
#include"SignalListener.hpp"
#include"ChatClient.hpp"
#include"SpeechSynthesis.hpp"

int main(int argc, char *argv[])
{
    set_qt_environment();

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    FileManager fileManager;
    fileManager.init();
    engine.rootContext()->setContextProperty("fileManager", &fileManager);  // 注册到QML环境
    // ThreadPool threadPool ;// 使用nullptr作为parent对象
    // engine.rootContext()->setContextProperty("threadPool", &threadPool);

    qmlRegisterType<SignalListener>("SignalListener", 1, 0, "SignalListener");
    qmlRegisterType<NetworkManager>("NetworkManager", 1, 0, "NetworkManager");
    qmlRegisterType<SpeechSynthesis>("SpeechSynthesis", 1, 0, "SpeechSynthesis");

    ChatClient chatClient;
    engine.rootContext()->setContextProperty("chatClient", &chatClient);
    QThread* clienThread = new QThread;
    chatClient.moveToThread(clienThread);
    clienThread->start();
    // load icon resource file
    app.setWindowIcon(QIcon(fileManager.assetsPath()+"icon.jpg"));

    const QUrl url(u"qrc:/qt/qml/Main/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    engine.addImportPath(":/");

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
