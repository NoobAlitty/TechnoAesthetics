import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import TechnoAesthetics
import Qt.labs.platform
import Qt5Compat.GraphicalEffects
import SignalListener

Page {
    SignalListener{
        id:imageSignal
        onSignal: {
            imageMutex=false;
            for (var key in result) {
                comboBoxList.setProperty(result[key].index,"path",result[key].path+"?t=" + new Date().getTime())
                comboBoxList.setProperty(result[key].index,"type",result[key].type)
                comboBoxList.setProperty(result[key].index,"Width",result[key].width)
                comboBoxList.setProperty(result[key].index,"Height",result[key].height)
            }
        }
        onHeightCalculation: {
            focalLengthText.text="Real focal length: "+result.focalLength+" mm";
            distanceText.text="Distance: "+result.distance+" m";
            unitPixelText.text="UnitPixel: "+result.unitPixel+" um";
            heightText.text="According to the test, your height is "+result.height+" cm";
            answerText.text=""+result.answer;
        }
    }
    width: 1200
    height: 800
    Component.onCompleted: {
        appWindow.width = width;
        appWindow.height = height;
        appWindow.x= (Screen.width - width) / 2
        appWindow.y= (Screen.height - height) / 2
        // imageProcessWindow.width = width;
        // imageProcessWindow.height = height;
        // imageProcessWindow.x= (Screen.width - width) / 2
        // imageProcessWindow.y= (Screen.height - height) / 2
    }
    property bool imageMutex: false
    property string lastAcceptedFile: "" // 创建一个新属性来存储最后一次成功打开的文件路径
    function processImage() {
        // 如果还没有文件被成功打开，则弹出提示并返回
        if (lastAcceptedFile === "") {
            dialogItem.dialog("Please Open a file at first!")
            return
        }
        else if(imageMutex===true){
            dialogItem.dialog("Image is processing!Please hold on!")
            return
        }
        imageMutex=true;
        var fileUrl = lastAcceptedFile
        var nums=[]
        for (let i = 1; i < comboBoxList.count; i++)
            nums.push(comboBoxList.get(i).opt)
        var imageProcessor= threadPool.create("image").set(imageSignal,nums, fileUrl, scaleSlider.value, comboBox3.currentIndex,comboBox1.currentIndex,comboBox2.currentIndex,textField.text,textField1.text,comboBox4.currentIndex,parseFloat(textField3.text))
        threadPool.add(imageProcessor)
    }

    DialogItem {
        id: dialogItem
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }
    FileDialog {
        id: fileDialog
        title: "Please choose an image"
        nameFilters: ["Image files (*.jpg *.png *.bmp)"]
        onAccepted: {
            lastAcceptedFile = fileDialog.file
            processImage()
        }
        onRejected: {
            // 这里可以添加一些操作，例如设置图片为默认图片
        }
    }
    // 背景图像
    Image {
        id:bg
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0 // 使图片铺满整个父元素
        // fillMode: Image.Stretch // 图片将被拉伸以填充矩形区域
        fillMode: Image.PreserveAspectCrop
        source: "https://img-baofun.zhhainiao.com/pcwallpaper_ugc/static/7df7af34243ab1f0e109e459111a69bc.jpg"/*fileManager.assetsPath()+"homepage.jpeg"*/
    }
    Text {
        id: text1
        x: 485
        y: 57
        opacity: 1
        color: "#c760ec"
        text: qsTr("Image processing with powerful OpenCV")
        font.pixelSize: 12
        scale: 3.931
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        anchors.leftMargin: 71
        anchors.rightMargin: 914
        anchors.topMargin: 191
        anchors.bottomMargin: 480
        spacing: 20

        Repeater {
            id: comboBoxRepeater
            model: comboBoxList
            delegate:ColumnLayout {
                RowLayout {
                    ComboBox {
                        id: comboBox
                        model: ["Zoom","ColorSpace", "SingleChannel", "TypeConvert","Histogram","Binary","ContrastRatio","Filter","LocalBinary","Strech","Compress","ProcessAnswerSheet","HeightDetectionSystem"]
                        Layout.fillWidth: true
                        Layout.minimumWidth: 150
                        Layout.minimumHeight: 50
                        visible: index>0
                        onCurrentIndexChanged: {
                            comboBoxList.setProperty(index,"opt",currentIndex)
                            processImage()
                        }
                    }
                    Button {
                        text: "+"
                        Layout.minimumWidth: 50
                        Layout.minimumHeight: 50
                        visible: index == comboBoxList.count - 1 // 只有最右边的组件显示加号按钮
                        onClicked: {
                            comboBoxList.append({"opt":comboBox.currentIndex,"path":"","type":"-","Width":0,"Height":0})
                        }
                    }
                }
                Button {
                    text: "-"
                    visible: index>0
                    onClicked: {
                        if(index!==0){
                            comboBoxList.remove(index)
                            processImage()
                        }
                    }
                }
                Column {
                    spacing: 5
                    Image {
                        id: image
                        // Layout.fillWidth: true
                        Layout.minimumWidth: 300
                        Layout.minimumHeight: 300
                        width: comboBoxList.get(index).Width/10
                        height:comboBoxList.get(index).Height/10
                        // width: 400
                        // height: 300
                        source: comboBoxList.get(index).path
                        // scale: 0.2
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        id: typeText
                        color: "#000000"
                        text: comboBoxList.get(index).type
                        font.pixelSize: 12
                        scale: 2
                    }

                    Text {
                        id: sizeText
                        color: "#000000"
                        text: comboBoxList.get(index).Width+"*"+comboBoxList.get(index).Height
                        font.pixelSize: 12
                        scale: 2
                    }
                }
            }
        }
    }

    ListModel {
        id: comboBoxList
        ListElement { opt:0;path:"" ;type:"-";Width:0;Height:0}
        ListElement { opt:0;path:"" ;type:"-";Width:0;Height:0}
    }
    // RowLayout{
        Text {
            id: options
            x: 60
            y: 143
            color: "#9dddef"
            text: qsTr("Options")
            font.pixelSize: 12
            scale: 2.73
        }
        ToolButton {
            id: toolButton
            x: 181
            y: 127
            text: qsTr("Upload")
            contentItem: Text {
                color: "#ddef2929"
                text: "Upload"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            icon.color: "#dde60f0f"
            scale: 1.747
            onClicked: fileDialog.open()
        }
        Text {
            id: text4
            x: 349
            y: 112
            color: "#eae170"
            text: qsTr("Scale")
            font.pixelSize: 12
            scale: 2.621
        }
        Slider {
            id: scaleSlider
            x: 269
            y: 130
            width: 191
            height: 48
            from: 0.1  // 最小缩放级别
            to: 1.9  // 最大缩放级别
            stepSize: 0.1  // 每次改变的缩放级别步长
            value: 1.0  // 初始缩放级别
            onValueChanged: processImage()
        }
        Text {
            id: text5
            x: 494
            y: 112
            color: "#eae170"
            text: qsTr("Color")
            font.pixelSize: 10
            scale: 2.621
        }
        ComboBox {
            id: comboBox1
            x: 457
            y: 131
            width: 100
            height: 69
            scale: 0.764
            model: ["HSV","Gray","YCrCb"]
            // visible: comboBox.currentText==="Single"
            onCurrentTextChanged: processImage()
        }
        Text {
            id: text6
            x: 598
            y: 112
            color: "#eae170"
            text: qsTr("Binary")
            font.pixelSize: 10
            scale: 2.621
        }

        ComboBox {
            id: comboBox2
            x: 564
            y: 131
            width: 100
            height: 69
            scale: 0.764
            model: ["BINARY","BINARY_INV","TRUNC","TOZERO","OZERO_INV"]
            onCurrentIndexChanged: processImage()
        }
        Text {
            id: text7
            x: 700
            y: 114
            color: "#eae170"
            text: qsTr("Channel")
            font.pixelSize: 10
            scale: 2.621
        }
        ComboBox {
            id: comboBox3
            x: 670
            y: 131
            width: 100
            height: 69
            scale: 0.764
            model: ["Red","Green","Blue"]
            onCurrentIndexChanged: processImage()
        }
        Text {
            id: text8
            x: 822
            y: 112
            color: "#eae170"
            text: qsTr("Alpha")
            font.pixelSize: 10
            scale: 2.621
        }
        TextField {
            id: textField
            x: 799
            y: 142
            width: 73
            height: 47
            // placeholderText: qsTr("2")
            text: qsTr("2")
            onTextChanged: processImage()
        }
        Text {
            id: text9
            x: 918
            y: 111
            color: "#eae170"
            text: qsTr("Beta")
            font.pixelSize: 10
            scale: 2.621
        }
        TextField {
            id: textField1
            x: 893
            y: 142
            width: 73
            height: 47
            // placeholderText: qsTr("50")
            text: qsTr("50")
            onTextChanged: processImage()
        }
        Text {
            id: text10
            x: 1032
            y: 111
            color: "#eae170"
            text: qsTr("Filter")
            font.pixelSize: 10
            scale: 2.621
        }
        ComboBox {
            id: comboBox4
            x: 977
            y: 131
            width: 139
            height: 69
            scale: 0.764
            model: ["Mean filtering","Gaussian filter","Median filtering"]
            onCurrentIndexChanged: processImage()
        }
        Text {
            id: text11
            x: 1124
            y: 111
            color: "#eae170"
            text: qsTr("distance")
            font.pixelSize: 10
            scale: 2.621
        }
        TextField {
            id: textField3
            x: 1109
            y: 142
            width: 73
            height: 47
            // placeholderText: qsTr("50")
            text: qsTr("3.0")
            // onTextChanged: processImage()
            onAccepted: processImage()
        }
    // }
        Column {
            x: 874
            y: 421
            spacing: 15
            Text {
                text: "Height detection system parameters"
                color: "#00CED1"
                font.pixelSize: 16
            }

            Text {
                text: "Equivalent focal length：26mm"
                color: "#6495ED"
                font.pixelSize: 16
            }

            Text {
                id:focalLengthText
                text: "Real focal length: 5.1mm"
                color: "#6495ED"
                font.pixelSize: 16
            }

            Text {
                id:unitPixelText
                text: "UnitPixel: 1.7um"
                color: "#6495ED"
                font.pixelSize: 16
            }

            Text {
                id:distanceText
                text: "distance: 3.0m"
                color: "#6495ED"
                font.pixelSize: 16
            }

            Text {
                id:heightText
                text: "According to the test, your height is 180.0 cm"
                color: "#6495ED"
                font.pixelSize: 16
            }

            Text {
                text: "Answer sheet"
                color: "#FF0000"
                font.pixelSize: 16
            }

            Text {
                id:answerText
                text: "There is no right answer!"
                color: "#FF45A0"
                font.pixelSize: 16
            }
        }

        // layer.enabled: true


}
