// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

#ifndef SORTFILTERMODEL_H
#define SORTFILTERMODEL_H

#include <QSortFilterProxyModel>
#include <QtQmlIntegration>

class SortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit SortFilterModel(QObject *parent = nullptr);
};

#endif // SORTFILTERMODEL_H
