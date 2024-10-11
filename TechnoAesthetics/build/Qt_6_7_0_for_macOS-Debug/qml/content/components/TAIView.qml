import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    width: 250
    height: 624


    Rectangle {
        id: cardRect
        anchors.centerIn: parent
        width: 200
        height: 100
        radius: 20
        color: "#FFFFFF"
        opacity: 0.8
        Image {
            id: backgroundImage
            anchors.fill: parent
            source: "https://itchronicles.com/wp-content/uploads/2020/11/where-is-ai-used-1024x683.jpg"
            fillMode: Image.PreserveAspectCrop
            // z: -1
        }

        // DropShadow {
        //     anchors.fill: cardRect
        //     horizontalOffset: 0
        //     verticalOffset: 5
        //     radius: 15
        //     samples: 17
        //     color: "#80000000"
        //     source: cardRect
        // }
    }

    Label {
        x: 16
        y: 55
        color: "#ddd131e3"
        text: "讯飞星火大语言模型"
        font.pixelSize: 24
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
    }

    Label {
        x: 12
        y: 126
        width: 226
        height: 81
        text: "这是一个强大的大语言模型,可以用于各种自然语言处理任务,如文本生成、问答等。它基于深度学习技术,拥有海量的训练数据,具有强大的语义理解能力。"
        wrapMode: Label.Wrap
        color: "#dd2828"
        font.italic: true
        font.bold: false
        font.pixelSize: 14
        Layout.fillWidth: true
    }

    RowLayout {
        x: 13
        y: 435
        Layout.fillWidth: true

        CheckBox {
            id: voiceCheckBox
            text: "开启语音"
            onCheckStateChanged: {
                setConfig()
            }
        }

        ComboBox {
            id: voiceComboBox
            model: ["youxiaoqin", "youxiaoxun", "youxiaofu","youxiaozhi"]
            currentIndex: 0
            onCurrentIndexChanged: {
                setConfig()
            }
        }
    }

    Label {
        x: 89
        y: 588
        text: "Techno_AI"
        font.pixelSize: 16
        Layout.alignment: Qt.AlignHCenter
    }

    signal configChanged(var configJson)
    function setConfig() {
        var config = {
            "voiceEnabled": voiceCheckBox.checked,
            "voiceName": voiceComboBox.currentText
        }
        configChanged(config);
    }
}


