import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: circleView
    background: Rectangle {
        color: "#F0F0F0"
    }

    ColumnLayout {
        spacing: 16
        anchors.margins: 16

        TextField {
            id: searchField
            placeholderText: qsTr("Search moments")
            onTextChanged: circleList.model.search(text)
        }

        ListView {
            id: circleList
            width: circleView.width
            height: circleView.height - searchField.height - (16 * 2)
            model: circleModel
            delegate: circleDelegate
        }

        Button {
            text: qsTr("New Moment")
            onClicked: {
                // 打开新动态发布界面
            }
        }
    }

    Component {
        id: circleDelegate
        Rectangle {
            width: circleList.width
            height: 120
            color: "#FFFFFF"
            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                TImage {
                    avatarSource: avatar
                    width: 48
                    height: 48
                }
                ColumnLayout {
                    spacing: 4
                    Label {
                        text: userName
                        font.bold: true
                    }
                    Label {
                        text: content
                        color: "#CCCCCC"
                        wrapMode: Label.Wrap
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    ListModel {
        id: circleModel

        ListElement {
            userName: "John Doe"
            content: "Just had a great lunch with my team!"
            avatar:""
        }

        // 添加更多的动态数据
    }
}
