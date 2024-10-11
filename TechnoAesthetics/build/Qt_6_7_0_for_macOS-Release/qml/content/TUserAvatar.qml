import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: userAvatar
    width: 80
    height: 80
    radius: width / 2
    color: "#CCCCCC"

    Image {
        id: avatarImage
        anchors.fill: parent
        source: "qrc:/images/default_avatar.png"
        fillMode: Image.PreserveAspectCrop
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // 处理头像点击事件
        }
    }
}
