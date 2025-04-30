pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

Control {
    id: container

    required property int row
    required property int column
    required property bool current
    required property bool editing
    required property bool selected
    required property var model

    background: Rectangle {
        border.width: container.current ? 2 : 0
        border.color: "blue"
        color: container.editing ? "red" : container.selected ? "yellow" : "white"
    }
    contentItem: Label {
        elide: Text.ElideRight
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        clip: false

        text: container.model.display ?? ""
        visible: !container.editing
    }

    Label {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pointSize: 7
        rightPadding: 2
        text: `${container.column + 1},${container.row + 1}`
    }

    TableView.editDelegate: TextField {
        width: container.width
        height: container.height
        verticalAlignment: TextField.AlignVCenter
        text: container.model.edit ?? container.model.display ?? ""

        TableView.onCommit: container.model.edit = text
    }
}
