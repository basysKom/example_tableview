// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

#include "tablemodel.h"

TableModel::TableModel(QObject *parent)
    : QAbstractTableModel{parent}
{
}

int TableModel::rowCount(const QModelIndex &parent) const
{
    return m_rows;
}

int TableModel::columnCount(const QModelIndex &parent) const
{
    return m_columns;
}

QVariant TableModel::data(const QModelIndex &index, int role) const
{
    QVariant result;

    if (index.row() < 0 || index.row() >= m_data.count())
        return result;

    const auto& row = m_data.at(index.row());

    if (index.column() < 0 || index.column() > row.rowData.count())
        return result;

    switch (role) {
    case Qt::DisplayRole:
        result = row.rowData.at(index.column()).value;
        break;
    default:
        break;
    }

    return result;
}

bool TableModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success = false;

    if (index.row() < 0 || index.row() >= m_data.count())
        return success;

    auto& row = m_data[index.row()];

    if (index.column() < 0 || index.column() > row.rowData.count())
        return success;

    auto& data = row.rowData[index.column()];

    switch (role) {
    case Qt::EditRole:
        data.value = value;
        success = true;
    default:
        break;
    }

    if (success)
        emit dataChanged(index, index, { Qt::DisplayRole });

    return success;
}

QHash<int, QByteArray> TableModel::roleNames() const
{
    return {
        { Qt::DisplayRole, "display" },
        { Qt::EditRole, "edit" }
    };
}

Qt::ItemFlags TableModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
}

void TableModel::setColumns(int columns)
{
    if (columns > m_columns) {
        beginInsertColumns({}, m_columns, m_columns);
        if (m_data.empty()) {
            setRows(1);
        }

        for (auto& row : m_data) {
            row.rowData.append({ .value = {} });
        }
        endInsertColumns();
    }

    if (m_columns > 0 && columns < m_columns) {
        beginRemoveColumns({}, m_columns - 1, m_columns - 1);
        for (auto& row : m_data) {
            row.rowData.removeLast();
        }
        endRemoveColumns();
    }

    m_columns = columns;
    emit columnCountChanged();
}

void TableModel::setRows(int rows)
{
    if (rows > m_rows) {
        beginInsertRows({}, m_rows, m_rows);
        TableRow row;
        for (int column = 0; column < m_columns; column++) {
            row.rowData.append({ .value = {} });
        }
        m_data.append(row);
        endInsertRows();
    }

    if (m_rows > 0 && rows < m_rows)
    {
        beginRemoveRows({}, m_rows - 1, m_rows - 1);
        m_data.removeLast();
        endRemoveRows();
    }

    m_rows = rows;
    emit rowCountChanged();
}
