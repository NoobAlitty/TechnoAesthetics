import QtQuick
import QtQuick.Controls
import TechnoAesthetics
import NetworkManager
import content

Page {
    NetworkManager {
        id: registerNet
        onRequestFinished:{
            // handleRequestFinished(response)
            dialogItem.dialog(response.message)
            if (response.status===201) {
                stackView.pop()
            }
        }
        onError: {
            dialogItem.dialog(errorString)
        }
    }
    NetworkManager {
        id: sendCodeNet
        onRequestFinished:{
            // handleRequestFinished(response)
            dialogItem.dialog(response.message)
        }
        onError: {
            dialogItem.dialog(errorString)
        }
    }
    VerificationCodeItem {
        id: verificationCodeItem
        width: 95
        height: 39
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 91
        anchors.horizontalCenterOffset: 89
        z:1
    }
    DialogItem {
        id: dialogItem
        x: 0
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
        anchors.verticalCenterOffset: 186
        anchors.horizontalCenterOffset: 34
        checkable: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if(email.text==="")
                dialogItem.dialog("Email can't be null!")
            else if(username.text==="")
                 dialogItem.dialog("Username can't be null!")
            else if(password.text==="")
                 dialogItem.dialog("Password can't be null!")
            else if(password.text!==rePassword.text)
                dialogItem.dialog("Please input the same password!")
            else{
                var registerForm = {
                    "email":email.text,
                    "code":code.text,
                    "username": username.text,
                    "password": password.text,
                }
                registerNet.post("/api/register",registerForm)
            }
        }
    }

    Text {
        id: emailText
        x: 197
        y: 44
        text: qsTr("email")
        font.pixelSize: 12
        scale: 1.965
    }

    TextField {
        id: email
        x: 292
        y: 32
        width: 204
        height: 38
        placeholderText: qsTr("")
    }

    Text {
        id: verificationText
        x: 180
        y: 103
        text: qsTr("verification")
        font.pixelSize: 12
        scale: 1.965
    }

    Button {
        id: btnCode
        x: 512
        y: 85
        text: qsTr("Send")
        onClicked: {
            if(email.text==="")
                dialogItem.dialog("Email can't be null!")
            else if(verification.text!==verificationCodeItem.verificationCode)
                dialogItem.dialog("Please input the right verification!")
            else {
                var EmailForm={
                    "email":email.text
                }
                sendCodeNet.post("/api/sendRegisterCode",EmailForm)
            }
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
    TextField {
        id: verification
        x: 294
        y: 92
        width: 94
        height: 38
        placeholderText: qsTr("")
    }
    TextField {
        id: code
        x: 292
        y: 149
        width: 204
        height: 38
        placeholderText: qsTr("")
    }
    TextField {
        id: username
        x: 292
        y: 216
        width: 204
        height: 38
        placeholderText: qsTr("")
    }

    TextField {
        id: password
        x: 292
        y: 285
        width: 204
        height: 38
        placeholderText: qsTr("")
        echoMode: TextField.Password  // 设置输入模式为密码模式
    }

    TextField {
        id: rePassword
        x: 294
        y: 359
        width: 204
        height: 38
        placeholderText: qsTr("")
        echoMode: TextField.Password  // 设置输入模式为密码模式
    }


    Text {
        id: text6
        x: 198
        y: 161
        text: qsTr("code")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text7
        x: 183
        y: 228
        text: qsTr("username")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text9
        x: 184
        y: 297
        text: qsTr("password")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text10
        x: 177
        y: 371
        text: qsTr("rePassword")
        font.pixelSize: 12
        scale: 1.965
    }


}
