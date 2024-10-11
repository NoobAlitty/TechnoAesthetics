import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SignalListener
ScrollView {
    property var friendJson:friendInfoJson
    signal contactClicked(int index)
    property int friendId:0
    property bool presenceExe:false
    property bool restart: false
    onRestartChanged: {
        contactModel.clear()
    }

    onPresenceExeChanged: {
        for (let i=0;i<contactModel.count;i++) {
            if(contactModel.get(i).userId===friendId){
                contactModel.setProperty(i,"presence",!contactModel.get(i).presence)
            }
        }
    }

    onFriendJsonChanged: {
        contactModel.clear()
        for (var i = 0; i < friendJson.length; i++) {
            var friend = friendJson[i]
            contactModel.appendContact(friend.nickname,friend.avatar,friend.id,friend.online)
        }
    }

    id: contactView
    width: 250
    height: 400
    background: Rectangle {
        color: "#F0F0F0"
    }
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: fileManager.assetsPath()+"contact.jpeg"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        z: -1 // 确保背景图在其他元素之下
    }
    ColumnLayout {
        spacing: 16
        anchors.margins: 16
        Button {
            id: btn
            text: qsTr("Friend manager")
            background: Rectangle {
                id: btnBackground
                color: mouseArea.containsMouse ? "#CCCCCC" : "#FFFFFF"
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // 打开新联系人添加界面
                    friendWindow.visible=true
                }
                onEntered: {
                    // 鼠标移入时改变按钮背景颜色
                    btnBackground.color = "#CCCCCC"
                }
                onExited: {
                    // 鼠标移出时恢复按钮背景颜色
                    btnBackground.color = "#FFFFFF"
                }
            }
        }
        ListView {
            id: contactList
            width: contactView.width
            height: contactView.height - btn.height
            model: contactModel
            delegate: contactDelegate
        }


    }

    Component {
        id: contactDelegate
        Rectangle {
            id: contactItem
            width: contactList.width
            height: 80
            color: mouseArea.containsMouse ? "#F0F0F0" : "#FFFFFF"
            Behavior on color { ColorAnimation { duration: 200 } }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // 处理联系人项被点击的逻辑
                    contactClicked(userId)
                }
                onEntered: {
                    // 鼠标移入时改变背景颜色
                    contactItem.color = "#F0F0F0"
                }
                onExited: {
                    // 鼠标移出时恢复背景颜色
                    contactItem.color = "#FFFFFF"
                }
            }

            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                TImage {
                    width: 48
                    height: 48
                    avatarSource: avatar
                }
                Column {
                    spacing: 1
                    Label {
                        text: nickname
                        font.bold: true
                    }
                    Label {
                        text: presence ? "Online":"Offline"
                        color: presence ? '#008000' : "#CCCCCC"
                        font.bold: true
                    }
                }
            }
        }
    }

    ListModel {
        id: contactModel
        function appendContact(nickname, avatar,userId,presence) {
            append({
                "nickname": nickname,
                "presence": presence,
                "avatar": avatar,
                "userId":userId,
            })
        }
    }
}
