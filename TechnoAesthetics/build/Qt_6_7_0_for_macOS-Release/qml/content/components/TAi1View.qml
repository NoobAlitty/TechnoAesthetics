import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#f0f0f0"
    property int currentId: 0
    property string userImage: "xxx"
    property var jsonData:({})
    property var groupJson: ({})
    property int myID: 0
    onJsonDataChanged: {
        clearAll();
        create();
    }
    onCurrentIdChanged: {
        stackLayout.currentIndex=chatClient.getIndex(currentId)
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0
    }

    function create() {
        Qt.createComponent("TChatGroupView.qml").createObject(stackLayout, {
                                                myImage: userImage,
                                                friendAvatar: "https://th.bing.com/th/id/R.b80e743c7f9cbcb09a25f90b7fdfcb92?rik=1E5h3YlJhKUNTQ&riu=http%3a%2f%2fpic23.photophoto.cn%2f20120520%2f0020033012632877_b.jpg&ehk=aoo6mnfENWGCz%2fCvu0nwFnBROuH62EaF7hoOr2Z0MRE%3d&risl=&pid=ImgRaw&r=0",
                                                friendId:1,
                                                friendNickname:"相亲相爱一家人",
                                                myUserId:myID,
                                                jsonDataX:groupJson
                                            })
        for (var i = 0; i < jsonData.length; i++) {
            var friend = jsonData[i]
            Qt.createComponent("TChatPrivateView.qml").createObject(stackLayout, {
                                                    myImage: userImage,
                                                    friendAvatar: friend.avatar,
                                                    friendId:friend.id,
                                                    friendNickname:friend.nickname
                                                })
        }
    }
    function clearAll() {
        for (var i = 0; i < stackLayout.count; i++) {
            var item = stackLayout.itemAt(i);
            if (item !== null) {
                item.destroy();
            }
        }
    }
}
