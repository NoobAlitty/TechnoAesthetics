import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
Rectangle {
    id: userAvatar
    radius: width / 2
    color: "#CCCCCC"
    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 20
    Layout.bottomMargin: 20
    property string avatarSource: ""
    OpacityMask {
        id:opacityMask
        anchors.fill: parent
        source: Image {
            id: avatarImage
            anchors.centerIn: parent
            source: avatarSource
            fillMode: Image.Pad
            smooth: true
            cache: true
            asynchronous: true
        }
        maskSource: Rectangle {
            width: userAvatar.width
            height: userAvatar.height
            radius: userAvatar.radius
        }
    }
}
