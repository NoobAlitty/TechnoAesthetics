// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import TechnoAesthetics
import QtQuick.Controls
import content

ApplicationWindow {
    id: appWindow
    visible: true
    title: qsTr("TechnoAesthetics")
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    Component {
        id: loginCompt
        LoginView {}
    }
    Component {
        id: registerCompt
        RegisterView {}
    }
    Component{
        id:homeCompt
        HomeView {}
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: LoginView{}
    }

}
