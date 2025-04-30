// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QAbstractTableModel>
#include <QtQmlIntegration>

class TableModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int columns READ columnCount WRITE setColumns NOTIFY columnCountChanged)
    Q_PROPERTY(int rows READ rowCount WRITE setRows NOTIFY rowCountChanged)

public:
    explicit TableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    void setColumns(int columns);
    void setRows(int newRows);

signals:
    void columnCountChanged();
    void rowCountChanged();

private:
    struct TableData {
        QVariant value;
    };

    struct TableRow {
        QList<TableData> rowData;
    };

    QList<TableRow> m_data;
    int m_columns = 0;
    int m_rows = 0;
};

#endif // TABLEMODEL_H
