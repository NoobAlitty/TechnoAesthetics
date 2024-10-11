import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechnoAesthetics
import NetworkManager
import SignalListener
Page {
    SignalListener{
        id:userSig
        onPresence: {
            isOnline=result
            if(isOnline){
                chatClient.refreshUserInfo()
            }
        }
        onSignal: {
            if(result.status===200){
                userInfoJson=result.data
                groupNet.get("my/getGroupInfo")
            }
        }
        onMessage: {
            messageView.isMe=isMe
            messageView.messageIndex=index
            messageView.messageContent=content
            messageView.messageExe=!messageView.messageExe
        }
        onFriendpresence: {
            contactView.friendId=friendId
            contactView.presenceExe=!contactView.presenceExe
        }
    }
    NetworkManager{
        id:friendNet
        onRequestFinished:{
            if (response.status === 200) {
                friendInfoJson=response.data
                chatClient.refreshMessage()
            }
        }
    }

    NetworkManager {
        id: groupNet
        onRequestFinished:{
            if (response.status === 200) {
                groupInfoJson=response.data
                friendNet.get("my/getFriendInfo")
            }
        }
    }
    id:homeView
    width: 1024
    height: 640
    Component.onCompleted: {
        userInfoJson={
            "nickname":"Noob",
            "age":16,
            "introduction":"666",
            "phone":911,
            "address":"Milky Way",
            "avatar":"https://img1.baidu.com/it/u=3156061178,596130969&fm=253&fmt=auto&app=138&f=JPEG?w=380&h=380",
            "sex":"girl",
            "id":0
        }
        chatClient.connectToServer()
        chatClient.userSigBind(userSig)
        appWindow.width = homeView.width;
        appWindow.height = homeView.height;
        messageButton.clicked()
    }
    property bool isOnline: false
    property var userInfoJson: ({})
    property var friendInfoJson: ({})
    property var groupInfoJson: ({})
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: fileManager.assetsPath()+"backgroundA.jpg"
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        z: -1 // 确保背景图在其他元素之下
    }
    DataEditDialog{
        id:dataEditDialog
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 第一列: 头像、消息、联系人、朋友圈
        ColumnLayout {
            id: leftColumn
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            spacing: 0

            // 设置
            TNavigationButton {
                id: settingButton
                text: qsTr("Setting")
                iconImageURLd: fileManager.assetsPath()+"setting.png"
                onClicked: {
                    settingsList.visible=true;
                    settingsDetails.visible=true;
                    messageView.visible = false;
                    contactView.visible = false;
                    chatView.visible = false;
                    contactInfoView.visible = false;
                    chatAIView.visible = false;
                    aiView.visible = false;
                }
            }

            //昵称
            Label{
                font.bold: true
                font.pixelSize: 22
                color: "#ADD8E6"
                text: userInfoJson.nickname
                Layout.topMargin: 20
                Layout.bottomMargin: 20
                Layout.leftMargin: 10
            }
            Row{
                // 头像
                TImage{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    Layout.bottomMargin: 20
                    avatarSource:userInfoJson.avatar
                    width: 80
                    height: 80
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dataEditDialog.visible=true
                        }
                    }
                }
                Column{
                    Label {
                        text: isOnline ? 'Online' : "Offline"
                        color: isOnline ? '#008000' : "#CCCCCC"
                        font.bold: true
                    }
                    Button {
                        id: myButton
                        icon.source: "https://hbimg.b0.upaiyun.com/3c5306e24f2ddb1742760bc475513de2675297fb10173-vhqxl8_fw658"
                        icon.width: 20
                        icon.height: 20
                        ToolTip.text: "You successfully refreshed the status!"
                        background: Rectangle {
                            color: myButton.down ? "#cccccc" : "#eeeeee"
                            radius: 4
                        }
                        contentItem: Row {
                            spacing: 8
                            IconImage {
                                source: myButton.icon.source
                                width: myButton.icon.width
                                height: myButton.icon.height
                            }
                        }
                        onClicked: {
                            reStart()
                        }
                    }
                }
            }


            // 消息
            TNavigationButton {
                id: messageButton
                text: qsTr("Message")
                iconImageURLd: fileManager.assetsPath()+"message.svg"
                onClicked: {
                    messageView.visible = true;
                    contactView.visible = false;
                    chatView.visible = true;
                    contactInfoView.visible = false;
                    chatAIView.visible = false;
                    aiView.visible = false;
                    settingsList.visible=false;
                    settingsDetails.visible=false;
                }
            }

            // 联系人
            TNavigationButton {
                id: contactButton
                text: qsTr("Contacts")
                iconImageURLd:fileManager.assetsPath()+"contact.jpg"
                onClicked: {
                    messageView.visible = false;
                    contactView.visible = true;
                    chatView.visible = false;
                    contactInfoView.visible = true;
                    chatAIView.visible = false;
                    aiView.visible = false;
                    settingsList.visible=false;
                    settingsDetails.visible=false;
                }
            }

            // AI
            TNavigationButton {
                id: aiButton
                text: qsTr("ChatAI")
                iconImageURLd:fileManager.assetsPath()+"ai.png"
                onClicked: {
                    messageView.visible = false;
                    contactView.visible = false;
                    chatAIView.visible = true;
                    aiView.visible = true;
                    chatView.visible = false;
                    contactInfoView.visible = false;
                    settingsList.visible=false;
                    settingsDetails.visible=false;
                }
            }

            // 图像处理工具
            TNavigationButton {
                id: imageProcessButton
                text: qsTr("Image Processing")
                iconImageURLd:fileManager.assetsPath()+"ImageProcess.png"
                onClicked: {
                    imageProcessWindow.visible=!imageProcessWindow.visible
                }
            }
        }

        // 第二列: 消息记录、联系人列表、朋友圈列表
        ColumnLayout {
            id: rightColumn
            Layout.fillHeight: true
            Layout.preferredWidth: 250
            spacing: 50

            TSettingsList {
                id: settingsList
                Layout.fillHeight: true
                onItemClicked: {
                    settingsDetails.currentIndex = index
                }
            }

            // 消息记录
            TMessageView {
                id: messageView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                onMessageClicked:{
                    chatView.currentId=index
                }
                width: 250
                height: homeView.height
            }

            // 联系人列表
            TContactView {
                id: contactView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                onContactClicked: {
                    contactInfoView.friendId=index
                }
                width: 250
                height: homeView.height
            }

            // AI列表
            TAIView {
                id: aiView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                width: 250
                height: homeView.height
                onConfigChanged: {
                    chatAIView.aiConfig=configJson
                }
            }
        }

        // 第三列: 聊天框、联系人信息、朋友圈详情
        ColumnLayout {
            id: rightColumn2
            Layout.fillHeight: true
            Layout.preferredWidth: 624
            spacing: 0

            TSettingsDetails {
                id: settingsDetails
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // 聊天框
            TChatView {
                id: chatView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                width: 624
                height: homeView.height
            }

            // 联系人信息
            TContactInfoView {
                id: contactInfoView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                width: 624
                height: homeView.height
            }

            TChatAIView {
                id: chatAIView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
                width: 624
                height: homeView.height
            }
        }
    }
    Window{
        id:imageProcessWindow
        visible: false
        // VisualInspectionSystem{
        // }
    }
    Window{
        id:friendWindow
        visible: false
        FriendView{}
    }
    function reStart(){
        messageView.restart=!messageView.restart
        chatView.restart=!chatView.restart
        contactView.restart=!contactView.restart
        if(!chatClient.reStart())
            groupNet.get("my/getGroupInfo")
    }
}
