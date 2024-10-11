import QtQuick
import QtQuick.Controls
import TechnoAesthetics
import NetworkManager

Page {
    NetworkManager {
        id: registerNet
        onRequestFinished:{
            // handleRequestFinished(response)
            cf.dialog(response.message)
            if (response.status===201) {
                stackView.pop()
            }
        }
        onError: {
            cf.dialog("Network connection error")
        }
    }
    NetworkManager {
        id: sendCodeNet
        onRequestFinished:{
            // handleRequestFinished(response)
            cf.dialog(response.message)
        }
        onError: {
            cf.dialog("Network connection error")
        }
    }
    VerificationCodeItem {
        id: verificationCodeItem
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
    }
    CommonFunctions {
        id: cf
        x: 22
        y: 0
        width: parent.width
        height: parent.height
    }
    width: 720
    height: 540
    Component.onCompleted: {
        appWindow.width = width;
        appWindow.height = height;
    }
    Image {
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0 // 使图片铺满整个父元素
        fillMode: Image.Stretch // 图片将被拉伸以填充矩形区域
        source: fileManager.assetsPath()+"register.png"
    }

    Button {
        id: button
        text: qsTr("Register")
        anchors.verticalCenter: parent.verticalCenter
        scale: 1.05
        highlighted: true
        flat: true
        icon.color: "#dd16c1e5"
        transformOrigin: Item.Center
        anchors.verticalCenterOffset: 217
        anchors.horizontalCenterOffset: 22
        checkable: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            var loginForm = {
                "username": username.text,
                "password": password.text
            }
            loginNet.post("/api/login",loginForm)
        }
    }
    TextField {
        id: username
        x: 283
        y: 209
        width: 222
        height: 56
        placeholderText: qsTr("")
    }

    TextField {
        id: password
        x: 283
        y: 293
        width: 222
        height: 56
        placeholderText: qsTr("")
        echoMode: TextField.Password  // 设置输入模式为密码模式
        onAccepted: button.clicked()  // 改动点，按下ENTER键时调用button的clicked方法
    }

    Text {
        id: text1
        x: 175
        y: 230
        text: qsTr("username")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text2
        x: 176
        y: 314
        text: qsTr("password")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text3
        x: 188
        y: 73
        text: qsTr("Email")
        font.pixelSize: 12
        scale: 1.965
    }

    TextField {
        id: username1
        x: 283
        y: 52
        width: 222
        height: 56
        placeholderText: qsTr("")
    }

    Text {
        id: text4
        x: 156
        y: 151
        text: qsTr("VerificationCode")
        font.pixelSize: 12
        scale: 1.965
    }

    TextField {
        id: username2
        x: 316
        y: 131
        width: 132
        height: 56
        placeholderText: qsTr("")
    }

    Text {
        id: text5
        x: 175
        y: 400
        text: qsTr("password")
        font.pixelSize: 12
        scale: 1.965
    }

    TextField {
        id: password1
        x: 283
        y: 379
        width: 222
        height: 56
        placeholderText: qsTr("")
        echoMode: TextField.Password
    }

    Button {
        id: button1
        x: 471
        y: 133
        text: qsTr("Send")
        onClicked: {
            var CodeForm={
                "email":text3.text
            }

            sendCodeNet.post("/api/sendRegisterCode",CodeForm)
        }
    }

    TabButton {
        id: tabButton
        x: 26
        y: 22
        text: qsTr("<back")
        font.pointSize: 18
        onClicked: {
            stackView.pop()
        }
    }
}
