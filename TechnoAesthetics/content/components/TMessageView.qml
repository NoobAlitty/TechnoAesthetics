import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    property var friendJson:friendInfoJson
    property var groupJson: groupInfoJson
    width: 250
    height: 400
    property bool restart: false
    property int contactInfoClick: 0
    property int messageIndex: 0
    property string messageContent: ""
    property bool isMe:false
    property bool messageExe: false
    signal messageClicked(int index)
    onRestartChanged: {
        messageModel.clear()
    }

    onMessageExeChanged: {
        setRedDot(messageIndex,messageContent)
    }
    onFriendJsonChanged: {
        for (var i = 0; i < friendJson.length; i++) {
            var friend = friendJson[i]
            messageModel.appendMessage("private",friend.id,friend.nickname,friend.avatar,"")
        }
        messageModel.setProperty(0, "selected", true) // 设置选中状态为 true
    }
    onGroupJsonChanged: {
        for (var i = 0; i < groupJson.length; i++) {
            var group = groupJson[i]
            messageModel.appendMessage("group",group.id,group.name,group.image,"")
        }
    }
    onContactInfoClickChanged: {
        clearSelection()
        messageModel.setProperty(contactInfoClick, "selected", true) // 设置选中状态为 true
        messageList.currentIndex = contactInfoClick // 设置当前索引
    }

    MediaPlayer {
        id: audioMedia
        source: fileManager.assetsPath()+"receiveMessage.mp3"
        audioOutput: AudioOutput {}
    }
    function setRedDot(index,lastMessage) {
        messageModel.setProperty(index,"lastMessage",lastMessage)
        messageModel.setProperty(index,"time",now())
        if(!isMe){
            messageModel.setProperty(index, "unreadCount", messageModel.get(index)["unreadCount"]+1)
            // 播放提醒音频
            audioMedia.play()
        }
    }

    function clearRedDot(index) {
        messageModel.setProperty(index, "unreadCount", 0);
    }
    ScrollView {
        id: messageView
        width: parent.width
        height: parent.height // 设置为固定值，根据需要调整
        background: Rectangle {
            color: "#F0F0F0"
        }

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: fileManager.assetsPath()+"backgroundA.jpg"
            fillMode: Image.PreserveAspectCrop
            anchors.centerIn: parent
            z: -1 // 确保背景图在其他元素之下
        }

        ColumnLayout {
            spacing: 16
            anchors.margins: 16

            Button {
                text: qsTr("New Message")
                onClicked: {
                    // 打开新消息编辑界面
                }
            }

            ListView {
                id: messageList
                width: messageView.width
                height: messageView.height - (16 * 2)
                model: messageModel
                delegate: messageDelegate
            }
        }
    }

    ListModel {
        id: messageModel

        function appendMessage(type,userId,nickname, avatar,lastMessage) {
            append({
                "type":type,
                "userId":userId,
                "nickname": nickname,
                "avatar": avatar,
                "time":now(),
                "selected": false,
                "unreadCount": 0,
                "lastMessage":lastMessage
            })
        }
        // 添加更多的消息数据
    }

    function now() {
        var date = new Date();
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return `${hours}:${minutes}`;
    }

    function clearSelection() {
        for (var i = 0; i < messageModel.count; i++) {
            var item = messageModel.get(i);
            if (item.selected) {
                messageModel.setProperty(i, "selected", false);
                break;
            }
        }
    }

    Component {
        id: messageDelegate
        Item {
            id: messageItem
            width: messageList.width
            height: 80

            Rectangle {
                id: background
                anchors.fill: parent
                color: selected ? "#2196F3" : (mouseArea.pressed ? "#E0E0E0" : (mouseArea.containsMouse ? "#F0F0F0" : "#FFFFFF"))
                border.color: "#E0E0E0"
                border.width: 1
                radius: 8 // 添加圆角

                Rectangle {
                     id: redDot
                     width: 20
                     height: 20
                     color: "#FF0000"
                     radius: width / 2
                     visible: unreadCount>0 // 控制红点的显示
                     anchors {
                         top: parent.top
                         right: parent.right
                         margins: 4
                     }

                     Text {
                         id: unreadCountText
                         text: unreadCount > 99 ? "99+" : unreadCount // 显示未读消息条数，大于99显示"99+"
                         color: "#FFFFFF"
                         font.pixelSize: 16
                         anchors.centerIn: parent
                         visible: unreadCount > 0 // 未读消息条数大于0时显示
                     }
                 }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        clearSelection(); // 清除先前选中项的状态
                        messageModel.setProperty(index, "selected", true) // 设置选中状态为 true
                        messageList.currentIndex = index // 设置当前索引
                        // currentIndex = index
                        if(type=="private")
                            messageClicked(chatClient.getIndex("private",userId))
                        else messageClicked(chatClient.getIndex("group",userId))
                        clearRedDot(index)
                    }
                }
            }

            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                TImage {
                    avatarSource: avatar
                    width: 48
                    height: 48
                }
                Column {
                    spacing: 4
                    Label {
                        text: nickname
                        font.bold: true
                    }
                    Label {
                        text: lastMessage
                        color: "#CCCCCC"
                    }
                }
                Item { Layout.fillWidth: true }
                Label {
                    text: time
                    color: "#CCCCCC"
                }
            }

            states: [
                State {
                    name: "Selected"
                    when: selected
                    PropertyChanges {
                        target: background
                        color: "#2196F3"
                    }
                }
            ]
            transitions: [
                Transition {
                    from: ""
                    to: "Selected"
                    PropertyAnimation {
                        target: background
                        property: "color"
                        duration: 100
                    }
                },
                Transition {
                    from: "Selected"
                    to: ""
                    PropertyAnimation {
                        target: background
                        property: "color"
                        duration: 100
                    }
                }
            ]
        }
    }
}
