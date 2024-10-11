// FileManager.cpp
#include "FileManager.h"
#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>

QString FileManager::_configPath="";
QString FileManager::_cachePath="";
QString FileManager::_assetsPath="";

FileManager::FileManager(QObject *parent) : QObject(parent)
{
}

void FileManager::init()
{
    _configPath=QCoreApplication::applicationDirPath() + "/config.json";
    _cachePath=QCoreApplication::applicationDirPath() + "/Cache/";
    _assetsPath=QCoreApplication::applicationDirPath() + "/qml/content/assets/";
    // 如果目录不存在，创建新的目录
    QDir cacheDir(_cachePath);
    if (!cacheDir.exists()) {
        cacheDir.mkpath(".");
    }

    // 如果配置文件不存在，创建一个新的配置文件并初始化 JSON 内容
    if (!QFile::exists(_configPath)) {
        QFile configFile(_configPath);
        if (configFile.open(QIODevice::WriteOnly)) {
            QJsonObject initialJson = {
                {"keepingType", false},
                {"username", ""},
                {"password", ""},
                {"token", ""}
            };
            QJsonDocument doc(initialJson);
            configFile.write(doc.toJson());
        }
    }
}

std::string FileManager::cacheAddFile(const QString& filename) const
{
    return (_cachePath+filename).toStdString();
}

QString FileManager::readFile(const QString& filePath) const
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "File not found: " << filePath;
        return QString();
    }
    return file.readAll();
}

void FileManager::writeFile(const QString& filePath, const QString& content)
{
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Cannot write to file: " << filePath;
        return;
    }
    file.write(content.toUtf8());
}

void FileManager::update(const QString& key, const QVariant& value)
{
    // 读取配置文件
    QJsonObject _cachedConfig = QJsonDocument::fromJson(readFile(_configPath).toUtf8()).object();
    _cachedConfig[key] = QJsonValue::fromVariant(value);
    QJsonDocument doc(_cachedConfig);
    writeFile(_configPath, QString(doc.toJson()));
}

QVariant FileManager::read(const QString& key, const QString& type) const
{
    // 读取配置文件
    QJsonObject _cachedConfig = QJsonDocument::fromJson(readFile(_configPath).toUtf8()).object();

    QVariant value;
    if (type == "string") {
        value = _cachedConfig[key].toString();
    } else if (type == "bool") {
        value = _cachedConfig[key].toBool();
    } else if (type == "int") {
        value = _cachedConfig[key].toInt();
    }
    return value;
}
QString FileManager::assetsPath(){
    return "file:///"+_assetsPath;
}
QString FileManager::cachePath(){
    return "file:///"+_cachePath;
}
