import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: parent.width
    height: 40
    color: ListView.isCurrentItem ? "#c0c0c0" : "transparent"

    property alias text: label.text

    signal clicked

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked()
        }
    }

    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
}
