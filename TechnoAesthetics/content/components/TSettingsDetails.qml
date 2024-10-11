import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
id: root
color: "#f0f0f0"
property int currentIndex: 0

StackLayout {
    anchors.fill: parent
    currentIndex: root.currentIndex

    // 账户设置详情页面
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Account Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他账户设置选项...
        }
    }

    // 消息设置详情页面
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Message Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他消息设置选项...
        }
    }

    // 其他设置详情页面...
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Notification Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他消息设置选项...
        }
    }
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Privacy Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他消息设置选项...
        }
    }
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Appearance Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他消息设置选项...
        }
    }
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20

            Label {
                text: "Other Settings"
                font.bold: true
                font.pixelSize: 20
            }

            // 其他消息设置选项...
        }
    }
}
}
