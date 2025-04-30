// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import com.basyskom.tableview

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: Application.displayName

    header: ToolBar {
        ColumnLayout {
            RowLayout {
                Label {
                    text: "Rows"
                }
                SpinBox {
                    id: rowSettings
                    from: 1
                    to: 20
                }

                ToolSeparator {}

                Label {
                    text: "Columns"
                }
                SpinBox {
                    id: columnSettings
                    from: 1
                    to: 20
                }

                ToolSeparator {}

                CheckBox {
                    id: movableColumnsSetting

                    text: "Movable columns"
                }

                ToolSeparator {}

                CheckBox {
                    id: resizableColumnsSetting

                    text: "Resizable columns"
                }
            }

            RowLayout {
                Label {
                    text: "Selection"
                }
                ComboBox {
                    id: selectionSetting
                    textRole: "text"
                    valueRole: "value"
                    model: [
                        { text: "disabled", value: TableView.SelectionDisabled },
                        { text: "by cells", value: TableView.SelectCells },
                        { text: "by rows", value: TableView.SelectRows },
                        { text: "by columns", value: TableView.SelectColumns }
                    ]

                    onCurrentIndexChanged: tableView.selectionModel.clear()
                }
                Label {
                    text: "Longpress to start selection, modify selection with CTRL/SHIFT of by mouse"
                    visible: selectionSetting.currentIndex > 0
                }
            }
        }
    }

    Rectangle {
        id: tableBackground

        anchors.fill: parent

        color: Application.styleHints.colorScheme === Qt.Light ? palette.mid : palette.midlight

        HorizontalHeaderView {
            id: horizontalHeader

            anchors.left: tableView.left
            anchors.top: parent.top

            syncView: tableView
            movableColumns: movableColumnsSetting.checked
            resizableColumns: resizableColumnsSetting.checked
            clip: true
            boundsBehavior: tableView.boundsBehavior

            delegate: HorizontalHeaderViewDelegate {
                onClicked: (sortOrder) => tableView.model.sort(column, sortOrder)
            }
        }

        VerticalHeaderView {
            id: verticalHeader

            anchors.top: tableView.top
            anchors.left: parent.left

            syncView: tableView
            clip: true
            boundsBehavior: tableView.boundsBehavior

            delegate: VerticalHeaderViewDelegate {}
        }

        TableView {
            id: tableView

            anchors.left: verticalHeader.right
            anchors.top: horizontalHeader.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            clip: true
            columnSpacing: 1
            rowSpacing: 1
            rowHeightProvider: (row) => 40
            boundsBehavior: TableView.StopAtBounds
            selectionModel: ItemSelectionModel {}
            selectionBehavior: selectionSetting.currentValue
            model: SortFilterModel {
                sourceModel: TableModel {
                    columns: columnSettings.value
                    rows: rowSettings.value

                    // when adding a new column its width isn't properly applied to the header, so we do that manually
                    onColumnsInserted: {
                        if (columns > 1) {
                            horizontalHeader.setColumnWidth(columns - 1, tableView.implicitColumnWidth(columns - 1))
                        }
                    }
                }
            }
            delegate: TableViewDelegate {
                implicitWidth: tableView.width / columnSettings.to
            }

            ScrollBar.horizontal: ScrollBar {}
            ScrollBar.vertical: ScrollBar {}
        }

        SelectionRectangle {
            target: tableView
        }
    }
}
