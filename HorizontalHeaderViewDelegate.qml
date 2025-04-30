// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick
import QtQuick.Controls

Control {
    id: container

    required property int column
    required property var model
    property int sortOrder: Qt.AscendingOrder

    signal clicked(int sortOrder)

    padding: 8

    background: Rectangle {
        color: tapHandler.pressed ? "gray" : "lightgray"

        TapHandler {
            id: tapHandler

            onTapped: {
                if (container.sortOrder === Qt.AscendingOrder) {
                    container.sortOrder = Qt.DescendingOrder
                } else {
                    container.sortOrder = Qt.AscendingOrder
                }

                container.clicked(container.sortOrder)
            }
        }
    }

    contentItem: Label {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: container.model.display
    }
}
