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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // 处理头像点击事件
            openAvatarEditDialog()
        }
    }

    function openAvatarEditDialog() {
        // 打开头像编辑对话框
        avatarEditDialog.open()
    }

    Dialog {
        id: avatarEditDialog
        title: qsTr("Edit Avatar")
        width: 400
        height: 400

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16

            OpacityMask {
                id: editedAvatar
                Layout.fillWidth: true
                Layout.fillHeight: true
                source: Image {
                    source: avatarImage.source
                    fillMode: Image.Pad
                    smooth: true
                    cache: true
                    asynchronous: true
                }
                maskSource: Rectangle {
                    width: editedAvatar.width
                    height: editedAvatar.height
                    radius: editedAvatar.width / 2
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 16

                Button {
                    text: qsTr("Cancel")
                    onClicked: avatarEditDialog.close()
                }

                Button {
                    text: qsTr("Save")
                    onClicked: {
                        // 保存编辑后的头像
                        avatarImage.source = editedAvatar.source
                        avatarEditDialog.close()
                    }
                }
            }
        }
    }
}
