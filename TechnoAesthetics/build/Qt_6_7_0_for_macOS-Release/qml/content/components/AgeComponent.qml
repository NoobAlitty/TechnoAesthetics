// AgeComponent.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: ageComponent

    property int selectedAge: 18

    ListView {
        id: ageListView
        anchors.top: parent.top
        anchors.leftMargin: 183
        anchors.topMargin: 93
        anchors.rightMargin: 391
        anchors.left: parent.left
        anchors.right: parent.right
        height: 245
        model: 83 // 18 to 100
        delegate: Text {
            text: 18 + index
            font.pixelSize: 24
            color: ageListView.currentIndex === index ? "#4CAF50" : "#757575"
            height: 40
            verticalAlignment: Text.AlignVCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    ageListView.currentIndex = index
                    selectedAge = 18 + index
                }
            }
        }
        currentIndex: selectedAge - 18
        snapMode: ListView.SnapToItem
        highlightFollowsCurrentItem: true
        preferredHighlightBegin: height / 2 - 20
        preferredHighlightEnd: height / 2 + 20
    }

    Text {
        text: "Age: " + selectedAge
        font.pixelSize: 24
        anchors.top: ageListView.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

// GenderComponent.qml
// (same as previous example)

// AgeAndGenderComponent.qml
// (same as previous example)
