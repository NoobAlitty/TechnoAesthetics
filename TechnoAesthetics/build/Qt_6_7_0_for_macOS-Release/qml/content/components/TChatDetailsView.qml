import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import SignalListener

ScrollView {
    property string myImage: ""
    property string friendAvatar: ""
    property string friendNickname: ""
    property int friendId: 0
    property int myUserId: 0
    property var jsonDataX:({})
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "https://data.1freewallpapers.com/download/sky-clouds-dusk-evening-sunset.jpg"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        z: -1 // 确保背景图在其他元素之下
    }

    SignalListener{
        id:chatSignal
        onSignal: {
            let isMe=false
            if(result.sender===myUserId)
                isMe=true
            let aVatar=myImage
            if(friendId===1){
                for (var i = 0; i < jsonDataX.length; i++) {
                    var friend = jsonDataX[i]
                    if(friend.id===result.sender){
                        aVatar=friend.avatar
                        break
                    }
                }
            }
            else {
                aVatar=isMe?myImage:friendAvatar
            }

            chatModel.addMessage(result.content,formatDateString(result.time), isMe,aVatar)

        }
    }
    Component.onCompleted: {
        chatList.positionViewAtEnd()
        if(friendId!==0)
            chatClient.bind(friendId,chatSignal)
    }

    id: chatDetailsView
    anchors.margins: 16

    background: Rectangle {
        color: "#F0F0F0"
    }

    ColumnLayout {
        id: mainLayout
        spacing: 16
        width: chatDetailsView.width
        height: chatDetailsView.height

        // 聊天标题
        Label {
            anchors.margins: 20
            text: friendNickname==""?"Chat":friendNickname
            // font.bold: true
            font.pixelSize: 26
            font.family: "Hiragino Sans GB"
            Layout.alignment: Qt.AlignTop
        }

        // 聊天内容
        ListView {
            id: chatList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: chatModel
            delegate: chatDelegate
            spacing: 16
            clip: true
        }

        // 消息输入框
        Rectangle {
            id: chatInput
            width: chatDetailsView.width
            height: 60
            color: "#FFFFFF"
            radius: 30
            Layout.alignment: Qt.AlignBottom

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                TextField {
                    id: inputField
                    placeholderText: qsTr("Type your message...")
                    Layout.preferredWidth: chatDetailsView.width * 0.8
                    background: Rectangle {
                        color: "transparent"
                    }
                    onAccepted:btnSend.clicked()
                }

                Button {
                    id:btnSend
                    Layout.preferredWidth: chatDetailsView.width * 0.15
                    text: qsTr("Send")
                    onClicked: {
                        if(friendId===1)
                            chatClient.sendGroupMessage(friendId,inputField.text,"text")
                        else chatClient.sendPrivateMessage(friendId,inputField.text,"text")
                        chatModel.addMessage(inputField.text,now(), true,myImage)
                        inputField.text = ""
                    }
                }
            }
        }
    }

    Component {
        id: chatDelegate

        ColumnLayout {
            anchors.right: isSentByMe ? parent.right : undefined
            anchors.left: isSentByMe ? undefined : parent.left
            spacing: 8

            RowLayout {

                TImage {
                    width: 40
                    height: 40
                    avatarSource: avatar
                }

                Label {
                    text: time
                    font.bold: true
                    font.pixelSize: 12
                    color: isSentByMe ? "#FFFFFF" : "#333333"
                }
            }
            // 聊天气泡
            Rectangle {
                id: chatBubble
                width: Math.max(implicitWidth + 20, text.implicitWidth + 30)
                height: Math.max(implicitHeight + 10, text.implicitHeight + 14)
                color: isSentByMe ? "#3B8DF9" : "#FFFFFF"
                radius: 16
                border.color: isSentByMe ? "#2675D7" : "#E0E0E0"
                border.width: 1
                anchors.topMargin: 8
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    color: "#40000000"
                    radius: 8
                    samples: 16
                    horizontalOffset: 0
                    verticalOffset: 4
                }

                Text {
                    id: text
                    anchors.right: isSentByMe ? chatBubble.right : undefined
                    anchors.left: isSentByMe ? undefined : chatBubble.left
                    anchors.verticalCenter: chatBubble.verticalCenter
                    text: content
                    color: isSentByMe ? "#FFFFFF" : "#333333"
                    font.family: "PingFang SC"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: isSentByMe ? Text.AlignRight : Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                    width: chatBubble.width - 20
                }
            }
        }
    }

    ListModel {
        id: chatModel

        onCountChanged: {
            chatList.positionViewAtEnd()
        }

        function addMessage(content, time,isSentByMe,avatar) {
            append({
                "content": content,
                "time": time,
                "isSentByMe": isSentByMe,
                "avatar":avatar
            })
        }

    }
    function now() {
        var date = new Date();
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }
    function formatDateString(dateString) {
        var date = new Date(dateString);
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }
}
