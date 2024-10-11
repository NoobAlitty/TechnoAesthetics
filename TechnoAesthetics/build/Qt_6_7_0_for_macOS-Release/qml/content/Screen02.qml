import QtQuick
import QtQuick.Controls
import TechnoAesthetics
import Qt.labs.platform

Page {
    width: 960
    height: 720
    Component.onCompleted: {
            appWindow.width = width;
            appWindow.height = height;
        }
    property string lastAcceptedFile: "" // 创建一个新属性来存储最后一次成功打开的文件路径
    property bool isFirst: true
    CommonFunctions {
        id: cf
        width: parent.width
        height: parent.height
    }
    // id: homepage
    // 背景图像
    Image {
        anchors.fill: parent // 使图片铺满整个父元素
        fillMode: Image.Stretch // 图片将被拉伸以填充矩形区域
        source: "file:///E:/Images/1.jpg"

        Text {
            id: text4
            x: 713
            y: 169
            color: "#eae170"
            text: qsTr("Scale")
            font.pixelSize: 12
            scale: 2.621
        }
    }
    ComboBox {
        id: comboBox1
        x: 380
        y: 291
        width: 139
        height: 69
        scale: 1.201
        model: ["Red","Green","Blue"]
        visible: comboBox.currentText==="Single"
        onCurrentTextChanged: processImage()
    }
    Item {
        id: __materialLibrary__
    }
    Text {
        id: text1
        x: 814
        y: 90
        opacity: 1
        color: "#c760ec"
        text: qsTr("Image processing with powerful OpenCV")
        font.pixelSize: 12
        scale: 3.931
    }
    Slider {
        id: scaleSlider
        x: 579
        y: 196
        width: 300
        from: 0.1  // 最小缩放级别
        to: 1.9  // 最大缩放级别
        stepSize: 0.1  // 每次改变的缩放级别步长
        value: 1.0  // 初始缩放级别
        onValueChanged: processImage()
    }
    function processImage() {
        // 如果还没有文件被成功打开，则弹出提示并返回
        if (lastAcceptedFile === "") {
            if(isFirst){
                isFirst=false
                return
            }
            cf.dialog("Please Open a file at first!")
            return
        }
        var fileUrl = lastAcceptedFile  // 使用 lastAcceptedFile 而不是 fileDialog.file
        // 现在我们知道 fileUrl 是有效的，可以进行图像处理
        var scaleValue=scaleSlider.value
        if(scaleValue>1)scaleValue=1+(scaleValue-1)*4
        threadPool.imageTask(comboBox.currentIndex,fileUrl.toString().replace("file:///", ""),scaleValue,comboBox1.currentIndex)
    }

    FileDialog {
        id: fileDialog
        title: "Please choose an image"
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.bmp)", "All files (*)"] // 仅显示图片文件
        onAccepted: {
            lastAcceptedFile = fileDialog.file
            processImage()
        }
        onRejected: {
            // 这里可以添加一些操作，例如设置图片为默认图片
        }
    }

    ComboBox {
        id: comboBox
        x: 389
        y: 190
        flat: false
        scale: 1.6
        model: ["None","Enhance", "ToHSV","Single","CovType"]
        onCurrentTextChanged: processImage()
    }

    ToolButton {
        id: toolButton
        x: 941
        y: 200
        text: qsTr("Upload")
        contentItem: Text {
            text: toolButton.text
            color: "#ddef2929"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        icon.color: "#dde60f0f"
        scale: 1.965
        onClicked: fileDialog.open()
    }

    Image {
        id: image
        x: 468
        y: 695
        width: sourceSize.width/30
        height: sourceSize.height/30
        source: ""
        scale: 6.005
        fillMode: Image.PreserveAspectFit
    }


    Image {
        id: image1
        x: 1352
        y: 695
        width: sourceSize.width/30
        height: sourceSize.height/30
        source: ""
        scale: 6.005
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text2
        x: 499
        y: 383
        color: "#7dd983"
        text: qsTr("Before")
        font.pixelSize: 12
        scale: 3.167
    }

    Text {
        id: text3
        x: 1359
        y: 382
        color: "#7dd983"
        text: qsTr("After")
        font.pixelSize: 12
        scale: 3.167
    }

    Text {
        id: options
        x: 180
        y: 216
        color: "#9dddef"
        text: qsTr("Options")
        font.pixelSize: 12
        scale: 3.712
    }

    Rectangle {
        id: container
        x: image.x
        y: image.y + image.height / 2 * image.scale + 40


        Column {
            spacing: 5

            Text {
                id: typeText
                color: "#000000"
                text: "-"
                font.pixelSize: 12
                scale: 2
            }

            Text {
                id: sizeText
                color: "#000000"
                text: "-"
                font.pixelSize: 12
                scale: 2
            }
        }
    }
    Rectangle {
        id: container1
        x: image1.x
        y: image1.y + image1.height / 2 * image1.scale + 40


        Column {
            spacing: 8

            Text {
                id: typeText1
                color: "#000000"
                text: "-"
                font.pixelSize: 12
                scale: 2
            }

            Text {
                id: sizeText1
                color: "#000000"
                text: "-"
                font.pixelSize: 12
                scale: 2
            }
        }
    }
    Connections {
        target: threadPool
        function onImageReady(result) {
            image.source=result[0].path+ "?t=" + new Date().getTime();
            image1.source = result[1].path + "?t=" + new Date().getTime();
            typeText.text = result[0].type;
            typeText1.text = result[1].type;
            sizeText.text=result[0].width+"*"+result[0].height;
            sizeText1.text=result[1].width+"*"+result[1].height;
        }
    }

}
