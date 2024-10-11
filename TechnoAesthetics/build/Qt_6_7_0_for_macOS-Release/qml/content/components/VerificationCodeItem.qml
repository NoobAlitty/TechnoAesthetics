// VerificationCodeItem.qml
import QtQuick
import QtQuick.Controls

Item {
    id: verificationCodeItem
    width: 300
    height: 80

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // 添加旋转或扭曲效果
            ctx.save();
            ctx.translate(width / 2, height / 2);
            ctx.rotate(Math.random() * 0.2 - 0.1);
            ctx.translate(-width / 2, -height / 2);

            // 绘制验证码文字
            ctx.font = "30px Arial";
            ctx.fillStyle = "black";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(verificationCode, width / 2, height / 2);

            ctx.restore();

            // 添加噪点
            for (var i = 0; i < 50; i++) {
                ctx.fillStyle = "rgba(0, 0, 0, " + Math.random() + ")";
                ctx.fillRect(Math.random() * width, Math.random() * height, 2, 2);
            }

            // 添加干扰线
            for (var j = 0; j < 5; j++) {
                ctx.beginPath();
                ctx.moveTo(Math.random() * width, Math.random() * height);
                ctx.lineTo(Math.random() * width, Math.random() * height);
                ctx.strokeStyle = "rgba(0, 0, 255, " + Math.random() + ")";
                ctx.lineWidth = Math.random() * 4 + 1;
                ctx.stroke();
            }
        }
    }

    property string verificationCode: generateRandomCode()

    function generateRandomCode() {
        var chars = "abcdefghijklmnopqrstuvwxyz";
        var result = "";
        for (var i = 0; i < 4; i++) {
            result += chars[Math.floor(Math.random() * chars.length)];
        }
        return result;
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            verificationCode = generateRandomCode();
            canvas.requestPaint();
        }
    }
}
