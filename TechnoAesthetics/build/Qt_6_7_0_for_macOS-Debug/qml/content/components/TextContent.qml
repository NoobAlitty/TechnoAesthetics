import QtQuick 2.15
Text {
    id: textContent
    anchors.verticalCenter: parent.verticalCenter
    color: isSentByMe ? "#FFFFFF" : "#333333"
    font.family: "PingFang SC"
    font.pixelSize: 16
    font.bold: true
    horizontalAlignment: isSentByMe ? Text.AlignRight : Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.Wrap
}
