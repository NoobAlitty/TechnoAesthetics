import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NetworkManager

ScrollView {
    id: contactInfoView
    property int friendId: 0
    property var friendJson:friendInfoJson
    property var friendInfo: ({})
    NetworkManager{
        id:deleteNet
        onRequestFinished: {
            if(response.status===200){
                friendInfo={
                    "avatar":"https://img.ytxfz.com/upload/2885125.jpg",
                    "nickname":"Noob",
                    "phone":911,
                    "email":"3w666@gmail.com",
                    "address":"milky way",
                    "introduction":"Good good study,day day up!",
                    "age":16,
                    "sex":"girl"
                }
                reStart()
            }
        }
    }
    Component.onCompleted: {
        friendInfo={
            "avatar":"https://img.ytxfz.com/upload/2885125.jpg",
            "nickname":"Noob",
            "phone":911,
            "email":"3w666@gmail.com",
            "address":"milky way",
            "introduction":"Good good study,day day up!",
            "age":16,
            "sex":"girl"
        }
    }

    onFriendIdChanged:{
        for (var i = 0; i < friendJson.length; i++) {
            var friend = friendJson[i]
            if(friend.id===friendId){
                friendInfo=friend
                break
            }
        }
    }
    onFriendJsonChanged: {
        friendInfo=friendJson[0]
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: fileManager.assetsPath()+"contactInfo.jpeg"
        fillMode: Image.PreserveAspectCrop
        // anchors.centerIn: parent
        z: -1 // 确保背景图在其他元素之下
    }
    background: Rectangle {
        color: "#F0F0F0"
    }

    ColumnLayout {
        spacing: 32
        anchors.margins: 32
        RowLayout{
            Rectangle {
                id: avatarContainer
                width: 120
                height: 120
                radius: width / 2
                color: "#CCCCCC"

                TImage {
                    id:tAvatar
                    anchors.fill: parent
                    avatarSource: friendInfo.avatar
                }
            }
            ColumnLayout{
                Label {
                    anchors.margins: 20
                    id: nameLabel
                    text: friendInfo.nickname
                    font.pixelSize: 24
                    font.bold: true
                }
                RowLayout{
                    Label {
                        anchors.margins: 20
                        id: ageLabel
                        text: friendInfo.age
                        color: "#CCCCCC"
                        font.bold: true
                    }

                    Label {
                        anchors.margins: 20
                        id: sexLabel
                        text: friendInfo.sex
                        color: "#CCCCCC"
                        font.bold: true
                    }
                }
            }
        }

        ColumnLayout {

            spacing: 16

            Label {
                anchors.margins: 20
                id: phoneLabel
                text: friendInfo.phone
                color: "#CCCCCC"
                font.bold: true
            }

            Label {
                anchors.margins: 20
                id: emailLabel
                text: friendInfo.email
                color: "#CCCCCC"
                font.bold: true
            }

            Label {
                id: addressLabel
                text: friendInfo.address
                color: "#CCCCCC"
            }
        }

        ColumnLayout {
            spacing: 16

            Label {
                text: qsTr("About")
                font.pixelSize: 18
                font.bold: true
            }

            Label {
                // anchors.centerIn: parent
                id:introductionLabel
                text: friendInfo.introduction
                color: "#CCCCCC"
                wrapMode: Label.Wrap
                Layout.fillWidth: true
                font.bold: true
            }
        }

        RowLayout {
            spacing: 16

            Button {
                text: qsTr("Message")
                onClicked: {
                    // 打开编辑联系人信息界面
                    contactView.visible=false
                    contactInfoView.visible=false
                    messageView.visible=true
                    chatView.visible=true
                    messageView.contactInfoClick=chatClient.getIndex("private",friendId)
                    chatView.currentId=chatClient.getIndex("private",friendId)
                }
            }

            Button {
                text: qsTr("Delete")
                onClicked: {
                    // 删除联系人
                    var postJson={
                        "friendId":friendId
                    }
                    deleteNet.post('my/deleteFriend',postJson)
                }
            }
        }
    }
}
