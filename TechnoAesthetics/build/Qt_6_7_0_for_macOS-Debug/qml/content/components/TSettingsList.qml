import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 250
    color: "#f0f0f0"

    property int currentIndex: 0
    signal itemClicked(int index)

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 10
        model: ListModel {
            id: settingsModel
            ListElement { text: "Account" }
            ListElement { text: "Message" }
            ListElement { text: "Notification" }
            ListElement { text: "Privacy" }
            ListElement { text: "Appearance" }
            ListElement { text: "Others" }
        }
        delegate: TSettingItem {
            text: model.text
            onClicked: {
                listView.currentIndex = index
                root.currentIndex = index
                root.itemClicked(index)
            }
        }
        currentIndex: root.currentIndex
    }
}
