#pragma once

#include <QObject>
#include <QString>
#include <QVariant>
#include <QJsonDocument>
#include <QJsonObject>

class FileManager : public QObject
{
    Q_OBJECT
public:
    static QString _configPath;
    static QString _cachePath;
    static QString _assetsPath;

    explicit FileManager(QObject *parent = nullptr);
    void init();
    std::string cacheAddFile(const QString& filename) const;
    QString readFile(const QString& filePath) const;
    void writeFile(const QString& filePath, const QString& content);
    Q_INVOKABLE void update(const QString& key, const QVariant& value);
    Q_INVOKABLE QVariant read(const QString& key, const QString& type) const;
    Q_INVOKABLE QString assetsPath();
    Q_INVOKABLE QString cachePath();
};
