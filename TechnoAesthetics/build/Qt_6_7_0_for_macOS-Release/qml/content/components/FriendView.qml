import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TechnoAesthetics
import NetworkManager

Rectangle {
    id: friendsView
    width: 800
    height: 600
    color: "#f2f2f2"
    Component.onCompleted: {
        friendWindow.width=width
        friendWindow.height=height
        inviteNet.get('my/getInvite')
        myTimer.start()
    }
    NetworkManager{
        id:searchNet
        onRequestFinished: {
            if(response.status===200){
                var searchData=response.data
                searchModel.clear()
                for (var i = 0; i < searchData.length; i++) {
                    var searchItem = searchData[i]
                    searchModel.appendSearch(searchItem.id,searchItem.nickname,searchItem.avatar,searchItem.introduction)
                }
            }
        }
    }
    NetworkManager{
        id:inviteNet
        onRequestFinished: {
            if(response.status===200){
                var inviteData=response.data
                inviteModel.clear()
                for (var i = 0; i < inviteData.length; i++) {
                    var inviteItem = inviteData[i]
                    inviteModel.appendInvite(inviteItem.id,inviteItem.nickname,inviteItem.avatar,inviteItem.introduction)
                }
            }
        }
    }
    NetworkManager{
        id:addNet
    }
    NetworkManager{
        id:handleNet
        onRequestFinished: {
            if(response.status===200){
                if(response.message==='confirmed')
                    reStart()
            }
        }
    }
    Timer {
        id: myTimer
        interval: 10000 // 1 second
        repeat: true
        running: false

        onTriggered: {
            // 定时器触发时执行的代码
            inviteNet.get('my/getInvite')
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 20

        // 左侧 - 收到的好友邀请
        Rectangle {
            id: invitesView
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "white"
            radius: 8
            border.color: "#e0e0e0"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20

                Label {
                    text: "The friend invitation received"
                    font.bold: true
                    font.pixelSize: 18
                }

                ListView {
                    id: invitesList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip: true
                    model: inviteModel
                    delegate: inviteDelegate
                }
            }
        }

        // 右侧 - 搜索好友
        Rectangle {
            id: searchView
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "white"
            radius: 8
            border.color: "#e0e0e0"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                Label {
                    text: "Search friends"
                    font.bold: true
                    font.pixelSize: 18
                }

                RowLayout {
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Please type a user name"
                        onAccepted: searchBtn.clicked()
                    }

                    Button {
                        id:searchBtn
                        text: "Search"
                        onClicked: {
                            var postJson={
                                "key":searchField.text
                            }
                            searchNet.post('my/searchFriend',postJson)
                        }
                    }
                }

                ListView {
                    id: searchList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip: true
                    model: searchModel
                    delegate: searchDelegate
                }
            }
        }
    }
    // 收到的好友邀请的代理组件
    Component {
        id: inviteDelegate
        Rectangle {
            width: invitesList.width
            height: 80
            color: "white"
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16

                TImage {
                    width: 40
                    height: 40
                    avatarSource: avatar
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: nickname
                        font.bold: true
                    }

                    Label {
                        text: introduction
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Button {
                    text: "Accept"
                    onClicked: {
                        var postJson={
                            "friendId":friendId,
                            "friendship_state":"confirmed"
                        }
                        handleNet.post('my/handleFriend',postJson)
                        inviteModel.remove(function(item) {
                            return item.friendId === friendId
                        })
                    }
                }

                Button {
                    text: "Reject"
                    onClicked: {
                        var postJson={
                            "friendId":friendId,
                            "friendship_state":"rejected"
                        }
                        handleNet.post('my/handleFriend',postJson)
                        inviteModel.remove(function(item) {
                            return item.friendId === friendId
                        })
                    }
                }
            }
        }
    }

    // 搜索结果的代理组件
    Component {
        id: searchDelegate
        Rectangle {
            width: searchList.width
            height: 80
            color: "white"
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16

                TImage {
                    width: 40
                    height: 40
                    avatarSource: avatar
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        text: nickname
                        font.bold: true
                    }

                    Label {
                        text: introduction
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Button {
                    text: "Add"
                    enabled: isNotFriend(friendId)
                    onClicked: {
                        enabled=false
                        var postJson={
                            "friendId":friendId
                        }
                        addNet.post('my/addFriend',postJson)
                    }
                }
            }
        }
    }
    ListModel {
        id: searchModel

        function appendSearch(friendId,nickname, avatar,introduction) {
            append({
                "friendId":friendId,
                "nickname": nickname,
                "avatar": avatar,
                "introduction":introduction
            })
        }
        // 添加更多的消息数据
    }
    ListModel {
        id: inviteModel

        function appendInvite(friendId,nickname, avatar,introduction) {
            append({
               "friendId":friendId,
               "nickname": nickname,
               "avatar": avatar,
                "introduction":introduction
            })
        }
        // 添加更多的消息数据
    }
    function isNotFriend(friendId){
        for (var i = 0; i < friendInfoJson.length; i++) {
            var friend = friendInfoJson[i]
            if(friend.id===friendId)
                return false
        }
        return true
    }
}

