// import QtQuick 6.2
// import TechnoAesthetics
// import QtQuick.Controls 6.2  // 导入QtQuick.Controls模块以使用StackView

// Item {
//     id: dialogItem

//     function dialog(textString){
//         dialogtext.text = textString
//         messageBox.visible = true
//     }

//     Dialog {
//         id: messageBox
//         visible: false

//         title: "Dialog"
//         modal: true

//         anchors.centerIn: parent
//         Text {
//             id: dialogtext
//             text: "There must be something wrong!"
//             scale: 1.15
//             anchors.centerIn: parent
//         }
//         Timer {
//             id: hideTimer
//             interval: 1000
//             running: false
//             repeat: false
//             onTriggered: messageBox.visible = false
//         }

//         onVisibleChanged: {
//             if (visible) {
//                 hideTimer.start()
//             }
//         }
//     }
// }

import QtQuick 6.2
import TechnoAesthetics
import QtQuick.Controls 6.2

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
