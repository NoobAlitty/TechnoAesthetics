#include "ImageProcessor.h"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <QCoreApplication>
#include<QDebug>
#include <QDir>
#include <iostream>
#include"FileManager.h"
FileManager FileManager;

ImageProcessor* ImageProcessor::set(SignalListener* signalListener,QList<int> Opts,QString Path, double Scale, int Channel,int Color,int BinaryType,int Alpha,int Beta,int BlurType,double Distance){
    opts=Opts,path=Path.mid(7),scale=Scale>1?1+(Scale-1)*4:Scale,channel=Channel,color=Color,binaryType=BinaryType,alpha=Alpha,beta=Beta,blurType=BlurType,distance=Distance;
    image = cv::imread(path.toStdString());
    connect(this,&ImageProcessor::taskFinished,signalListener,&SignalListener::onSignal);
    connect(this,&ImageProcessor::heightCalculation,signalListener,&SignalListener::onHeightCalculation);
    return this;
}
QString ImageProcessor::write(const QString& filname){
    std::string outputPath = FileManager.cacheAddFile(filname+"."+QFileInfo(path).suffix());
    cv::imwrite(outputPath, image);
    return QString::fromStdString(outputPath);
}
QJsonObject ImageProcessor::info(QString Path,int index){
    QJsonObject info;
    if (image.empty())
        return info;
    info["path"]="file://"+Path;
    switch (image.depth()) {
    case CV_8U:
        info["type"]="uint8";
        break;
    case CV_64F:
        info["type"]="double";
        break;
    default:
        info["type"]="Unknown";
    }
    info["height"]=image.rows;
    info["width"]=image.cols;
    info["index"]=index;
    return info;
}

void ImageProcessor::run(){
    QJsonObject result;
    if(image.empty()){
        emit taskFinished(result);
        return;
    }
    result["Image-0"] = info(write("Image-0"),0);
    for(int i=0;i<opts.size();i++){
        switch (opts[i]) {//["Zoom","ColorSpace", "SingleChannel", "TypeConvert","Histogram","Binary","ContrastRatio","Filter","LocalBinary","Stretch","Compress","ProcessAnswerSheet","HeightDetectionSystem"]
        case 0:
            zoom();
            break;
        case 1:
            colorSpace();
            break;
        case 2:
            singleChannel();
            break;
        case 3:
            typeConvert();
            break;
        case 4:
            histogram();
            break;
        case 5:
            binary();
            break;
        case 6:
            contrastRatio();
            break;
        case 7:
            filter();
            break;
        case 8:
            localBinary();
            break;
        case 9:
            stretch();
            break;
        case 10:
            compress();
            break;
        case 11:
            processAnswerSheet();
            break;
        case 12:
            heightDetectionSystem();
            break;
        }
        QString filename="Image-"+QString::number(i+1);
        result[filename] = info(write(filename),i+1);
    }
    emit taskFinished(result);
}


ImageProcessor* ImageProcessor::zoom(){
    if(scale<1)cv::resize(image, image, cv::Size(), scale, scale, cv::INTER_AREA);
    else cv::resize(image, image, cv::Size(), scale, scale, cv::INTER_LINEAR);
    return this;
}


ImageProcessor* ImageProcessor::singleChannel(){
    std::vector<cv::Mat> channels(3);
    cv::split(image, channels);
    switch (channel) {
    case 0:
        image = channels[2]; // 对于BGR格式，红色通道是第2个
        break;
    case 1:
        image = channels[1]; // 对于BGR格式，绿色通道是第1个
        break;
    case 2:
        image = channels[0]; // 对于BGR格式，蓝色通道是第0个
        break;
    }
    return this;
}
ImageProcessor* ImageProcessor::typeConvert() {
    // Check the type of the input image
    if (image.depth() == CV_8U) {
        // Input image is uint8 type, convert to double and normalize
        image.convertTo(image, CV_64F, 1.0 / 255.0);
    } else if (image.depth() == CV_64F) {
        // Input image is double type, convert to uint8 and denormalize
        image.convertTo(image, CV_8U, 255.0);
    } else {
        qDebug() << "Error: Unsupported image type.";
    }
    return this;
}
ImageProcessor* ImageProcessor::histogram(){
    // 进行直方图均衡化
    cv::equalizeHist(image, image);
    return this;
}
ImageProcessor* ImageProcessor::binary(){
    // 二值化参数
    double thresh = 128.0; // 阈值
    double maxval = 255.0; // 最大值
    // 二值化类型THRESH_BINARY= 0, THRESH_BINARY_INV = 1, THRESH_TRUNC= 2, THRESH_TOZERO= 3, THRESH_TOZERO_INV = 4
    cv::threshold(image, image, thresh, maxval, binaryType);
    return this;
}
ImageProcessor* ImageProcessor::contrastRatio(){
    // 对比度调整参数:alpha 对比度增益,beta 亮度偏移
    // 对比度调整
    cv::convertScaleAbs(image, image, alpha, beta);
    return this;
}
ImageProcessor* ImageProcessor::colorSpace(){
    switch (color) {
    case 0:
        cv::cvtColor(image,image,cv::COLOR_BGR2HSV);
        break;
    case 1:
        cv::cvtColor(image,image,cv::COLOR_BGR2GRAY);
        break;
    case 2:
        cv::cvtColor(image, image, cv::COLOR_BGR2YCrCb);
        break;
    }
    return this;
}
ImageProcessor* ImageProcessor::filter(){
    switch(blurType){
    case 0:
        cv::blur(image, image, cv::Size(5, 5)); // 使用5x5的内核进行均值/平滑滤波
        break;
    case 1:
        cv::GaussianBlur(image, image, cv::Size(5, 5), 0); // 使用5x5的内核进行高斯滤波
        break;
    case 2:
        cv::medianBlur(image, image, 5); // 使用5x5的内核进行中值滤波
        break;
    }
    return this;
}
ImageProcessor* ImageProcessor::localBinary(){
    //局部阈值二值化
    cv::adaptiveThreshold(image, image, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 9, 1);
    // 调用OpenCV的自适应阈值分割函数
    // cv::adaptiveThreshold(image, image, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, blockSize, constant);
    return this;
}
ImageProcessor* ImageProcessor::stretch(){
    //灰度拉伸
   cv::normalize(image, image, 0, 255, cv::NORM_MINMAX);
    return this;
}
ImageProcessor* ImageProcessor::compress(){
    //灰度压缩
    cv::normalize(image, image, 0, 127, cv::NORM_MINMAX);
    return this;
}
// 自定义函数：按顺时针排序点
void sortPointsClockwise(std::vector<cv::Point>& points) {
    cv::Point center(0, 0);
    for (int i = 0; i < points.size(); i++) {
        center += points[i];
    }
    center *= (1.0 / points.size());
    //比较极坐标
    std::sort(points.begin(), points.end(), [center](const cv::Point& a, const cv::Point& b) {
        return atan2(a.y - center.y, a.x - center.x) < atan2(b.y - center.y, b.x - center.x);
    });
}
bool correct(cv::Mat& image){
    //高斯滤波降噪
    cv::GaussianBlur(image, image, cv::Size(5, 5), 0); // 使用5x5的内核进行高斯滤波
    // cv::medianBlur(image, image, 5); // 使用5x5的内核进行中值滤波

    // 将图像转换为灰度图像
    cv::cvtColor(image, image, cv::COLOR_BGR2GRAY);

    // 自适应阈值处理
    cv::adaptiveThreshold(image, image, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 9, 1);

    // 进行边缘检测
    cv::Mat edges;
    cv::Canny(image, edges, 50, 150);

    // 查找轮廓
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(edges, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    // 寻找最大轮廓(答题纸)
    double maxArea = 0;
    int maxContourIndex = -1;
    for (size_t i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if (area > maxArea) {
            maxArea = area;
            maxContourIndex = i;
        }
    }

    // 提取最大轮廓的四个顶点
    std::vector<cv::Point> maxContour = contours[maxContourIndex];
    std::vector<cv::Point> approx;
    cv::approxPolyDP(maxContour, approx, cv::arcLength(maxContour, true) * 0.02, true);

    // 如果没找到四个顶点，则退出
    if (approx.size() != 4)
        return false;

    //进行透视变换
    // 确保顶点按照顺时针顺序排列
    sortPointsClockwise(approx);

    // 计算透视变换矩阵
    cv::Point2f srcPoints[4];
    cv::Point2f dstPoints[4];

    for (int i = 0; i < 4; i++) {
        srcPoints[i] = approx[i];
    }

    // 目标矩形的顶点位置
    dstPoints[0] = cv::Point(0, 0);
    dstPoints[1] = cv::Point(image.cols - 1, 0);
    dstPoints[2] = cv::Point(image.cols - 1, image.rows - 1);
    dstPoints[3] = cv::Point(0, image.rows - 1);

    // 计算透视变换矩阵
    cv::Mat transformMatrix = cv::getPerspectiveTransform(srcPoints, dstPoints);

    // 应用透视变换
    cv::Mat warpedImage;
    cv::warpPerspective(image, warpedImage, transformMatrix, image.size());
    image=warpedImage;
    return true;
}
ImageProcessor* ImageProcessor::processAnswerSheet() {
    //矫正不成功就返回
    if(!correct(image))return this;

    //寻找最大连通域（选择题）
    std::vector<std::vector<cv::Point>> contours;
    int largestContourIndex = -1;
    double largestArea = 0.0;
    cv::findContours(image, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    for (size_t i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if (area > largestArea) {
            largestArea = area;
            largestContourIndex = i;
        }
    }
    cv::Rect largestRect = cv::boundingRect(contours[largestContourIndex]);
    image = image(largestRect);

    //反向二值化,得到黑白反转的图像
    cv::threshold(image, image, 0, 255, cv::THRESH_BINARY_INV);

    //消除干扰连通域
    int width=image.cols/4;
    int length=width/4.4;
    double minAspectRatio = 0.7; // 设置最小长宽比
    double maxAspectRatio = 2.5; // 设置最大长宽比
    double minROIArea=image.rows*image.cols/2500;
    double maxROIArea=image.rows*image.cols/500;
    cv::findContours(image, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    std::vector<cv::Rect> validRegions;
    for (const auto& contour : contours) {
        cv::Rect rect = cv::boundingRect(contour);
        double area = rect.width * rect.height;
        double aspectRatio = static_cast<double>(rect.width) / rect.height;
        // // 过滤掉面积过小和长宽比过大的连通域
        if (aspectRatio < maxAspectRatio && aspectRatio > minAspectRatio && area > minROIArea&& area<maxROIArea)
            validRegions.emplace_back(rect);
    }

    //填充答案连通域
    image = cv::Mat::zeros(image.size(), image.type());
    for (const auto& rect : validRegions) {
        image(rect) = 255;
    }

    // 先按 y 坐标升序排序
    std::sort(validRegions.begin(), validRegions.end(), [](const cv::Rect& a, const cv::Rect& b) {
        return a.y < b.y;
    });

    // 然后对每 4 个矩形区域按 x 坐标升序排序
    for (size_t i = 0; i < validRegions.size(); i += 4) {
        std::sort(validRegions.begin() + i, validRegions.begin() + std::min(i + 4, validRegions.size()), [](const cv::Rect& a, const cv::Rect& b) {
            return a.x < b.x;
        });
    }
    // 创建一个QHash
    QHash<int,QString> answer;
    QString answerStr="";
    // 添加键值对
    answer.insert(1,"A");
    answer.insert(2,"B");
    answer.insert(3,"C");
    answer.insert(4,"D");

    int k=1;
    for (const auto& rect : validRegions) {
        QString s=answer[(int)(rect.x%width/length)+1];
        if(!s.isEmpty())answerStr+=s;
        if(k%4==0)answerStr+="    ";
        if(k++%16==0)answerStr+="\n";
    }
    QJsonObject info;
    info["answer"]=answerStr;
    emit heightCalculation(info);
    return this;
}

ImageProcessor* ImageProcessor::heightDetectionSystem(){
    //高斯模糊降噪
    cv::GaussianBlur(image, image, cv::Size(5, 5), 0);

    // 将图像转换为灰度图像
    cv::cvtColor(image, image, cv::COLOR_BGR2GRAY);

    //二值化
    cv::threshold(image, image, 33, 255, cv::THRESH_BINARY);

    //反二值化
    cv::threshold(image, image, 0, 255, cv::THRESH_BINARY_INV);

    //查找轮廓
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(image, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    // 过滤轮廓
    double minAspectRatio = 2.0; // 设置最小长宽比
    double maxAspectRatio = 3.0; // 设置最大长宽比
    int largestContourIndex = -1;
    double maxArea = 0;
    for (size_t i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        cv::Rect rect = cv::boundingRect(contours[i]);
        double aspectRatio = static_cast<double>(rect.height) / rect.width;
        if (aspectRatio < maxAspectRatio && aspectRatio > minAspectRatio) {
            if (area > maxArea) {
                maxArea = area;
                largestContourIndex = i;
            }
        }
    }
    cv::Rect largestContourRect = cv::boundingRect(contours[largestContourIndex]);
    image = image(largestContourRect);

    //获取像素高度并计算
    if (largestContourIndex != -1) {
        QJsonObject info;
        //Small hole imaging principle: height/distance = image height/focal length = pixel height * Unit pixel/focal length
        double height=largestContourRect.height*unitPixel/1000/focalLength*distance*100;
        info["height"]=QString::number(height, 'f', 2);
        info["focalLength"]=focalLength;
        info["distance"]=distance;
        info["unitPixel"]=unitPixel;
        emit heightCalculation(info);
    } else {
        // 未检测到合适的轮廓
        QJsonObject info;
        info["height"] = "N/A";
        emit heightCalculation(info);
    }
    return this;
}
