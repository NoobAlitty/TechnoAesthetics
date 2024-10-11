import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    property string iconImageURLd: ""
    id: navigationButton
    flat: true
    display: AbstractButton.TextUnderIcon
    font.pixelSize: 14
    icon.width: 24
    icon.height: 24
    icon.color: (checked || hovered) ? "#2196F3" : "#CCCCCC"
    contentItem: Column {
        spacing: 4
        Image {
            id: buttonIcon
            source: iconImageURLd
            Layout.alignment: Qt.AlignHCenter
            width: 30
            height: 30
            fillMode: Image.PreserveAspectCrop
            // anchors.centerIn: parent
        }
        Label {
            text: navigationButton.text
            color: (checked || hovered) ? "#2196F3" : "#CCCCCC"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    background: Rectangle {
        color: (checked || hovered) ? "#F0F0F0" : "transparent"
        radius: 8
    }
}
