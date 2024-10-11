import QtQuick
import TechnoAesthetics
import QtQuick.Controls

Item {
    id: dialogItem

    function dialog(textString) {
        dialogtext.text = textString
        messageBox.visible = true
    }

    Dialog {
        id: messageBox
        visible: false

        title: "TechnoAesthetics"
        modal: true
        standardButtons: Dialog.Close
        anchors.centerIn: parent
        width: 300
        height: 180

        background: Rectangle {
            color: "#ffffff"
            radius: 8
            border.color: "#d9d9d9"
            border.width: 1
        }

        Text {
            id: dialogtext
            text: "There must be something wrong!"
            font.pixelSize: 18
            color: "#333333"
            anchors.centerIn: parent
        }

        Timer {
            id: hideTimer
            interval: 3000
            running: false
            repeat: false
            onTriggered: messageBox.visible = false
        }

        onVisibleChanged: {
            if (visible) {
                hideTimer.start()
            }
        }
    }
}
