import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#f0f0f0"
    // property int currentId: 0
    // property string myAvatar: ""


    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0
    }
    Component.onCompleted: {
        create()
    }

    // onMyAvatarChanged: {
    //     clearAll();
    //     create();
    // }

    function create() {
        Qt.createComponent("TChatAIView.qml").createObject(stackLayout, {
                                                myAvatar: userInfoJson.avatar,
                                                aiAvatar: "https://img95.699pic.com/photo/30257/2922.jpg_wh300.jpg",
                                                aiId:1,
                                                aiName:"Artificial intelligence"
                                            })
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
