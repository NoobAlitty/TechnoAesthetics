#pragma once

#include <QObject>
#include <QString>
#include<QDebug>
// #include <opencv2/core/core.hpp>
#include"TaskBase.hpp"
#include"SignalListener.hpp"

class ImageProcessor : public TaskBase
{
    Q_OBJECT
private:
    // cv::Mat image;
    QList<int> opts;
    QString path;
    double scale;
    int channel;
    int color;
    int binaryType;
    int alpha;
    int beta;
    int blurType;
    double distance;
    double focalLength=5.1;
    double unitPixel=1.7;
public:
    ImageProcessor(){}
    Q_INVOKABLE ImageProcessor* set(SignalListener*,QList<int>,QString, double, int,int,int,int,int,int,double);
    void run() override;
    QString write(const QString& filname);
    QJsonObject info(QString,int);
signals:
    void heightCalculation(const QJsonObject& result);
public slots:
    ImageProcessor* zoom();//缩放
    ImageProcessor* colorSpace();//调整色彩空间
    ImageProcessor* singleChannel();//转换单通道
    ImageProcessor* typeConvert();//图像类型转换
    ImageProcessor* histogram();//直方图均衡化
    ImageProcessor* binary();//二值化
    ImageProcessor* contrastRatio();//调整对比度
    ImageProcessor* filter();//噪声滤波
    ImageProcessor* localBinary();//自适应局部二值化
    ImageProcessor* stretch();//灰度拉伸
    ImageProcessor* compress();//灰度压缩
    ImageProcessor* processAnswerSheet();//矫正处理答题卡
    ImageProcessor* heightDetectionSystem();//身高检测系统
};
