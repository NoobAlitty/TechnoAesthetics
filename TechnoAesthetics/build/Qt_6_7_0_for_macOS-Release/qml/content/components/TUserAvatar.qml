import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import Qt.labs.platform
Rectangle {
    id: userAvatar
    radius: width / 2
    color: "#CCCCCC"
    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 20
    Layout.bottomMargin: 20
    OpacityMask {
        id:opacityMask
        anchors.fill: parent
        source: Image {
            id: avatarImage
            anchors.centerIn: parent
            source: userInfoJson.avatar
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
        dataEditDialog.open()
    }

    // Dialog {
    //     id: dataEditDialog
    //     title: qsTr("Personal data editing")
    //     width: 400
    //     height: 400

    //     ColumnLayout {
    //         anchors.fill: parent
    //         anchors.margins: 16

    //         OpacityMask {
    //             id: editedAvatar
    //             Layout.fillWidth: true
    //             Layout.fillHeight: true
    //             source: Image {
    //                 source: avatarImage.source
    //                 fillMode: Image.Pad
    //                 smooth: true
    //                 cache: true
    //                 asynchronous: true
    //             }
    //             maskSource: Rectangle {
    //                 width: editedAvatar.width
    //                 height: editedAvatar.height
    //                 radius: editedAvatar.width / 2
    //             }
    //         }

    //         RowLayout {
    //             Layout.alignment: Qt.AlignRight
    //             spacing: 16

    //             Button {
    //                 text: qsTr("Cancel")
    //                 onClicked: avatarEditDialog.close()
    //             }

    //             Button {
    //                 text: qsTr("Save")
    //                 onClicked: {
    //                     // 保存编辑后的头像
    //                     avatarImage.source = editedAvatar.source
    //                     avatarEditDialog.close()
    //                 }
    //             }
    //         }
    //     }
    // }
    Dialog {
        id: dataEditDialog
        title: qsTr("Personal Data Editing")
        // width: 500
        // height: 500

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            OpacityMask {
                id: editedAvatar
                Layout.fillWidth: true
                Layout.fillHeight: true
                width: 400
                height: 400
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
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fileDialog.open()
                    }
                }
            }

            TextField {
                id: ageField
                placeholderText: qsTr("Age")
                Layout.fillWidth: true
            }

            TextField {
                id: signatureField
                placeholderText: qsTr("Signature")
                Layout.fillWidth: true
            }

            TextField {
                id: phoneField
                placeholderText: qsTr("Phone")
                Layout.fillWidth: true
            }

            TextField {
                id: addressField
                placeholderText: qsTr("Address")
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 16

                Button {
                    text: qsTr("Cancel")
                    onClicked: dataEditDialog.close()
                }

                Button {
                    text: qsTr("Save")
                    onClicked: {
                        // 保存编辑后的个人信息
                        // avatarImage.source = editedAvatar.source
                        // ageText.text = ageField.text
                        // signatureText.text = signatureField.text
                        // phoneText.text = phoneField.text
                        // addressText.text = addressField.text
                        dataEditDialog.close()
                    }
                }
            }
        }

        FileDialog {
            id: fileDialog
            title: qsTr("Choose Avatar")
            onAccepted: {
                editedAvatar.source = fileDialog.fileUrl
            }
        }
    }
}
