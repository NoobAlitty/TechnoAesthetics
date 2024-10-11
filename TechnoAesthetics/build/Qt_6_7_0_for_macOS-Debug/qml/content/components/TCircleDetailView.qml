import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: circleDetailView
    background: Rectangle {
        color: "#F0F0F0"
    }

    ColumnLayout {
        spacing: 32
        anchors.margins: 32

        Rectangle {
            id: avatarContainer
            width: 80
            height: 80
            radius: width / 2
            color: "#CCCCCC"

            TImage {
                id: avatar
                anchors.fill: parent
                avatarSource: "qrc:/images/avatar.png"
                // layer.enabled: true
            }
        }

        Label {
            id: nameLabel
            text: qsTr("John Doe")
            font.pixelSize: 18
            font.bold: true
        }

        Label {
            id: contentLabel
            text: qsTr("Just had a great lunch with my team!")
            color: "#CCCCCC"
            wrapMode: Label.Wrap
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 16

            Button {
                text: qsTr("Like")
                onClicked: {
                    // 点击"赞"按钮
                }
            }

            Button {
                text: qsTr("Comment")
                onClicked: {
                    // 打开评论输入界面
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: qsTr("Delete")
                onClicked: {
                    // 删除动态
                }
            }
        }

        Label {
            text: qsTr("Comments")
            font.pixelSize: 18
            font.bold: true
        }

        ListView {
            id: commentList
            width: circleDetailView.width
            height: 200
            model: commentModel
            delegate: commentDelegate
        }
    }

    ListModel {
        id: commentModel

        ListElement {
            userName: "Jane Doe"
            comment: "Great lunch!"
        }

        ListElement {
            userName: "Bob Smith"
            comment: "Looks like fun!"
        }

        // 添加更多的评论数据
    }

    Component {
        id: commentDelegate
        Rectangle {
            width: commentList.width
            height: 60
            color: "#FFFFFF"
            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                TImage {
                    avatarSource: "qrc:/images/avatar.png"
                    width: 32
                    height: 32
                    // layer.enabled: true


                }
                Column {
                    spacing: 4
                    Label {
                        text: userName
                        font.bold: true
                    }
                    Label {
                        text: comment
                        color: "#CCCCCC"
                    }
                }
            }
        }
    }
}
