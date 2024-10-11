import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import SignalListener
import QtMultimedia
import NetworkManager
// import content
ScrollView {
    property var groupInfo:({})
    property var userInfo:({})
    property var userJson:({})

    Component.onCompleted: {
        chatList.positionViewAtEnd()
        if(groupInfo.id!==0){
            chatClient.bind("group",groupInfo.id,chatSignal)
            groupUserNet.get("my/getGroupUser?groupId="+groupInfo.id)
        }
    }

    NetworkManager{
        id:groupUserNet
        onRequestFinished: {
            userJson=response.data
        }
    }

    MediaPlayer {
        id: audioMedia
        source: fileManager.assetsPath()+"sendMessage.mp3"
        audioOutput: AudioOutput {}
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: fileManager.assetsPath()+"backgroundA.jpg"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        z: -1 // 确保背景图在其他元素之下
    }

    SignalListener{
        id:chatSignal
        onSignal: {
            if(result.sender===userInfo.id){
                chatModel.addMessage(result.content,formatDateString(result.time), true,userInfo.avatar,userInfo.nickname,result.format)
            }
            else{
                for (var i = 0; i < userJson.length; i++) {
                    var User = userJson[i]
                    if(User.id===result.sender){
                        chatModel.addMessage(result.content,formatDateString(result.time), false,User.avatar,User.nickname,result.format)
                        break
                    }
                }
            }
            chatList.positionViewAtEnd()
        }
    }

    id: chatDetailsView
    anchors.margins: 16
    height: parent.height
    width: parent.width
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
            text: groupInfo.name
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
                        if(isHttpImage(inputField.text)){
                            chatClient.sendGroupMessage(groupInfo.id,inputField.text,"image")
                            chatModel.addMessage(inputField.text,now(), true,userInfo.avatar,userInfo.nickname,"image")
                        }
                        else{
                            chatClient.sendGroupMessage(groupInfo.id,inputField.text,"text")
                            chatModel.addMessage(inputField.text,now(), true,userInfo.avatar,userInfo.nickname,"text")
                        }
                        inputField.text = ""
                        audioMedia.play()
                    }
                }
            }
        }
    }

    Component {
        id: chatDelegate

        ColumnLayout {
            Component.onCompleted: {
                if(isSentByMe)
                    anchors.right=parent.right
                else
                    anchors.left=parent.left
            }
            spacing: 8

            RowLayout {
                Layout.alignment: isSentByMe ? Qt.AlignRight : Qt.AlignLeft
                // Component.onCompleted: {
                //     if(isSentByMe)
                //         anchors.right=parent.right
                //     else
                //         anchors.left=parent.left
                // }
                TImage {
                    width: 40
                    height: 40
                    avatarSource: groupAvatar
                }
                ColumnLayout{
                    Label{
                        text:nickname
                        font.bold: true
                        font.pixelSize: 14
                        color: isSentByMe ? "#FFFFFF" : "#333333"
                    }
                    Label {
                        text: time
                        font.bold: true
                        font.pixelSize: 12
                        color: isSentByMe ? "#FFFFFF" : "#333333"
                    }
                }
            }
            Rectangle {
                id: chatBubble

                TextContent {
                    id: textContent
                    visible: format === "text"
                    text: content
                    color: isSentByMe ? "#FFFFFF" : "#333333"
                }
                ImageContent {
                    id: imageContent
                    visible: format === "image"
                    source: format === "image"?content:""
                    // onContentReady: {
                    //     chatBubble.width=imageContent.width
                    //     chatBubble.height=imageContent.height
                    // }
                }
                width: format==="text"?textContent.implicitWidth + 16:200
                height: format==="text"?textContent.implicitHeight + 16:200
                color: isSentByMe ? "#3B8DF9" : "#FFFFFF"
                radius: 16
                border.color: isSentByMe ? "#2675D7" : "#E0E0E0"
                border.width: 1
                layer.enabled: true
                layer.effect: DropShadow {
                    id:shadow
                    transparentBorder: true
                    color: "#40000000"
                    radius: 8
                    samples: 16
                    horizontalOffset: 0
                    verticalOffset: 4
                }

                Layout.alignment: isSentByMe ? Qt.AlignRight : Qt.AlignLeft
                // Component.onCompleted: {
                //     if(isSentByMe)
                //         anchors.right=parent.right
                //     else
                //         anchors.left=parent.left
                //     // if(format==="text"){
                //     //     chatBubble.color=isSentByMe ? "#3B8DF9" : "#FFFFFF"
                //     //     chatBubble.border.color= isSentByMe ? "#2675D7" : "#E0E0E0"
                //     // }
                //     // else {
                //     //     shadow.visible=false
                //     //     chatBubble.layer.enabled=false
                //     // }
                // }
            }
        }
    }

    ListModel {
        id: chatModel

        onCountChanged: {
            chatList.positionViewAtEnd()
        }

        function addMessage(content, time,isSentByMe,groupAvatar,nickname,format) {
            append({
                "content": content,
                "time": time,
                "isSentByMe": isSentByMe,
                "groupAvatar":groupAvatar,
                "nickname":nickname,
                "format":format
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
    function isHttpImage(str) {
        // 检查字符串是否以 "http" 开头
        var httpRegex = /^http/

        // 检查 URL 路径是否以常见的图像文件扩展名结尾
        var imageRegex = /(\.png|\.jpg|\.jpeg|\.gif|\.svg)$/i

        return imageRegex.test(str)||httpRegex.test(str)
    }
}
