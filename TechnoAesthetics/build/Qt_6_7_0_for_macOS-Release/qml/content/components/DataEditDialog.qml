import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.platform
import TechnoAesthetics
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import QtQuick.Controls.Material 2.15
import NetworkManager
Window {
    NetworkManager{
        id:userInfoNet
        onRequestFinished: {
            if(response.status===200){
                userInfoJson=response.data
            }
        }
    }

    id: dataEditDialog
    visible: false
    title: qsTr("Personal Data Editing")
    width: 500
    height: 500
    modality: Qt.ApplicationModal

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        RowLayout{
            anchors.fill: parent
            // anchors.margins: 10
            // spacing: 10
            OpacityMask {
                id: editedAvatar
                // Layout.fillWidth: true
                // Layout.fillHeight: true
                width: 200
                height: 200
                source: Image {
                    id:avatarImage
                    source: userInfoJson.avatar
                    fillMode: Image.Pad
                    smooth: true
                    cache: true
                    asynchronous: true
                }
                maskSource: Rectangle {
                    width: editedAvatar.width
                    height: editedAvatar.height
                    radius: editedAvatar.width / 2
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fileDialog.open()
                    }
                }
            }
            ColumnLayout{
                TextField {
                    id: ageField
                    placeholderText: userInfoJson.age
                }
                ComboBox {
                    id: sexComboBox
                    model: ["girl","boy","other"]
                    currentIndex: userInfoJson.sex==="girl"?0:(userInfoJson==="boy"?1:2)
                }
            }
        }

        TextField {
            id: signatureField
            placeholderText: userInfoJson.introduction
            Layout.fillWidth: true
        }

        TextField {
            id: phoneField
            placeholderText: userInfoJson.phone
            Layout.fillWidth: true
        }

        TextField {
            id: addressField
            placeholderText: userInfoJson.address
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 16

            Button {
                text: qsTr("Cancel")
                onClicked: {
                    clearAll()
                    dataEditDialog.visible=false
                }
            }

            Button {
                text: qsTr("Save")
                onClicked: {
                    // 保存编辑后的个人信息
                    var userJsonData=userInfoJson
                    if(ageField.text!=="")userJsonData.age=ageField.text
                    if(sexComboBox.currentIndex!==userInfoJson.sex==="girl"?0:(userInfoJson==="boy"?1:2))
                        userJsonData.sex=sexComboBox.currentIndex===0?"girl":sexComboBox.currentIndex===1?"boy":"other"
                    if(signatureField.text!=="")userJsonData.introduction=signatureField.text
                    if(phoneField.text!=="")userJsonData.phone=phoneField.text
                    if(addressField.text!=="")userJsonData.address=addressField.text
                    userInfoNet.post('/my/updateUserInfo',userJsonData)
                    clearAll()
                    dataEditDialog.visible=false
                }
            }
        }
    }
    function clearAll(){
        ageField.text=""
        sexComboBox.currentIndex=userInfoJson.sex==="girl"?0:(userInfoJson==="boy"?1:2)
        signatureField.text=""
        phoneField.text=""
        addressField.text=""
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Choose Avatar")
        onAccepted: {
            editedAvatar.source = fileDialog.fileUrl
        }
    }
}
