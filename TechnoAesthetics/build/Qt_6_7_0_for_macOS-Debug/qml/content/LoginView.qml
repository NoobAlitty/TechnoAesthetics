import QtQuick
import QtQuick.Controls
import TechnoAesthetics
import NetworkManager
import content
Page {
    id:loginView

    NetworkManager {
        id: loginNet
        onRequestFinished:{
            // handleRequestFinished(response)
            if (response.status !== 200) {
                dialogItem.dialog(response.message)
            } else {
                fileManager.update("token",response.data.token)
                fileManager.update("username",username.text)
                if(radioButton.checked)
                    fileManager.update("password",password.text)
                else fileManager.update("password","")
                stackView.push(homeCompt)
            }
        }
        onError: {
            dialogItem.dialog(errorString)
            // stackView.push(homeCompt)
        }
    }
    DialogItem {
        id: dialogItem
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
        anchors.fill: parent // 使图片铺满整个父元素
        fillMode: Image.Stretch // 图片将被拉伸以填充矩形区域
        source:fileManager.assetsPath()+'login.jpeg'
    }

    Button {
        id: button
        text: qsTr("Login")
        anchors.verticalCenter: parent.verticalCenter
        scale: 1.05
        highlighted: true
        flat: true
        icon.color: "#dd16c1e5"
        transformOrigin: Item.Center
        anchors.verticalCenterOffset: 144
        anchors.horizontalCenterOffset: 0
        checkable: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if(username.text==="")
                 dialogItem.dialog("Username can't be null!")
            else if(password.text==="")
                 dialogItem.dialog("Password can't be null!")
            else{
                var loginForm = {
                    "username": username.text,
                    "password": password.text
                }
                loginNet.post("/api/login",loginForm)
            }
        }
    }

    Text {
        id: label
        x: 269
        y: 66
        text: qsTr("Welcome to TechnoAesthetics")
        // anchors.top: button.bottom
        font.family: Constants.font.family
        anchors.topMargin: -361
        anchors.horizontalCenterOffset: 0
        scale: 1.856
        // anchors.horizontalCenter: parent.horizontalCenter
    }
    TextField {
        id: username
        x: 283
        y: 156
        width: 222
        height: 56
        text: fileManager.read("username","string")
        placeholderText: qsTr("")
    }

    TextField {
        id: password
        x: 283
        y: 253
        width: 222
        height: 56
        text: fileManager.read("password","string")
        placeholderText: qsTr("")
        echoMode: TextField.Password  // 设置输入模式为密码模式
        onAccepted: button.clicked()  // 改动点，按下ENTER键时调用button的clicked方法
    }

    Text {
        id: text1
        x: 177
        y: 176
        text: qsTr("username")
        font.pixelSize: 12
        scale: 1.965
    }

    Text {
        id: text2
        x: 177
        y: 273
        text: qsTr("password")
        font.pixelSize: 12
        scale: 1.965
    }

    RadioButton {
        id: radioButton
        x: 220
        y: 332
        visible: true
        text: qsTr("keep password")
        checked: fileManager.read("keepingType","bool")
        autoRepeat: false
        checkable: false
        clip: false
        state: ""
        onCheckedChanged: checked=fileManager.read("keepingType","bool")
        onClicked: {
            fileManager.update("keepingType",!radioButton.checked)
            radioButton.checked=!radioButton.checked
        }
    }

    TabButton {
        id: tabButton
        x: 432
        y: 332
        text: qsTr("Go to register>")
        font.pointSize: 16
        onClicked: {
            stackView.push(registerCompt)
        }
    }
}
