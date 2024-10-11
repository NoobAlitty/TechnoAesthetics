import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#f0f0f0"
    property int currentId: 0
    property var friendJson:friendInfoJson
    property var groupJson: groupInfoJson
    property bool restart: false

    onRestartChanged: {
        clearAll()
    }

    onFriendJsonChanged: {
        createFriendChat();
    }

    onGroupJsonChanged: {
        createGroupChat();
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: currentId
    }

    function createFriendChat() {
        for (var i = 0; i < friendJson.length; i++) {
            var friend = friendJson[i]
            Qt.createComponent("TChatPrivateView.qml").createObject(stackLayout, {
                                                    userInfo:userInfoJson,
                                                    friendInfo:friend
                                                })
        }
    }
    function createGroupChat() {
        for (var i = 0; i < groupJson.length; i++) {
            var group = groupJson[i]
            Qt.createComponent("TChatGroupView.qml").createObject(stackLayout, {
                                                    userInfo:userInfoJson,
                                                    groupInfo:group
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
