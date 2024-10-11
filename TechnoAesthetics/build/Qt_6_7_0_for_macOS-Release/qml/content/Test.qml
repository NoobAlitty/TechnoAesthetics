import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TechnoAesthetics
import content 1.0
// import "qrc:/components/TUserAvatar.qml" as TUserAvatar
// import "qrc:/components/TNavigationButton.qml" as TNavigationButton
// import "qrc:/components/TMessageView.qml" as TMessageView
// import "qrc:/components/TContactInfoView.qml" as TContactInfoView
// import "qrc:/components/TCircleDetailView.qml" as TCircleDetailView
// import "qrc:/components/TChatView.qml" as TChatView
// import "qrc:/components/TCircleView.qml" as TCircleView
// import "qrc:/components/TContactView.qml" as TContactView

Page {
    id: homePage
    width: 1200
    height: 720
    Component.onCompleted: {
        appWindow.width = width;
        appWindow.height = height;
    }
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // 第一列: 头像、消息、联系人、朋友圈
        ColumnLayout {
            id: leftColumn
            Layout.fillHeight: true
            Layout.preferredWidth: 200
            spacing: 0

            // 头像
            TUserAvatar {
                id: userAvatar
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                Layout.bottomMargin: 20
            }

            // 消息
            TNavigationButton {
                id: messageButton
                text: qsTr("Message")
                icon.source: "qrc:/icons/message.svg"
                onClicked: {
                    rightColumn.visible = true
                    rightColumn2.visible = false
                    messageView.visible = true
                    contactView.visible = false
                    circleView.visible = false
                }
            }

            // 联系人
            TNavigationButton {
                id: contactButton
                text: qsTr("Contacts")
                icon.source: "qrc:/icons/contacts.svg"
                onClicked: {
                    rightColumn.visible = true
                    rightColumn2.visible = false
                    messageView.visible = false
                    contactView.visible = true
                    circleView.visible = false
                }
            }

            // 朋友圈
            TNavigationButton {
                id: circleButton
                text: qsTr("Moments")
                icon.source: "qrc:/icons/moments.svg"
                onClicked: {
                    rightColumn.visible = true
                    rightColumn2.visible = true
                    messageView.visible = false
                    contactView.visible = false
                    circleView.visible = true
                }
            }
        }

        // 第二列: 消息记录、添加联系人、朋友圈列表
        ColumnLayout {
            id: rightColumn
            Layout.fillHeight: true
            Layout.preferredWidth: 400
            spacing: 0

            // 消息记录
            TMessageView {
                id: messageView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // 添加联系人
            TContactView {
                id: contactView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // 朋友圈列表
            TCircleView {
                id: circleView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        // 第三列: 聊天框、联系人信息、朋友圈详情
        ColumnLayout {
            id: rightColumn2
            Layout.fillHeight: true
            Layout.preferredWidth: 600
            spacing: 0

            // 聊天框
            TChatView {
                id: chatView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // 联系人信息
            TContactInfoView {
                id: contactInfoView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // 朋友圈详情
            TCircleDetailView {
                id: circleDetailView
                visible: false
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }
}
