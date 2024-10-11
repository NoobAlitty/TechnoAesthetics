import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
Image {
    id: imageContent

    // smooth: true
    // cache: true
    // anchors.verticalCenter: parent.verticalCenter
    width: 200
    height: 200
    property int maxWidth: 400
    property int maxHeight: 400
    signal contentReady(bool contentState)
    // border.left: 8; border.top: 8
    // border.right: 8; border.bottom: 8

    // layer.enabled: true
    // layer.effect: DropShadow {
    //     transparentBorder: true
    //     color: "#40000000"
    //     radius: 8
    //     samples: 16
    //     horizontalOffset: 0
    //     verticalOffset: 4
    // }
    // onStatusChanged: {
    //     if(source!==""&&status===Image.Ready&&height===0&&width===0){
    //         height=Math.min(sourceSize.height/4, maxHeight)
    //         width=Math.min(sourceSize.width/4, maxWidth)
    //         contentReady(true)
    //     }
    // }
}
