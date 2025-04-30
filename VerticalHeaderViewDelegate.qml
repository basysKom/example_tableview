import QtQuick
import QtQuick.Controls

Control {
    id: container

    required property int row
    required property var model

    padding: 8

    background: Rectangle {
        color: tapHandler.pressed ? "gray" : "lightgray"

        TapHandler {
            id: tapHandler
        }
    }

    contentItem: Label {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: container.model.display
    }
}
