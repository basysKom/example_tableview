// SPDX-FileCopyrightText: 2025 Martin Leutelt <martin.leutelt@basyskom.com>
// SPDX-FileCopyrightText: 2025 basysKom GmbH
//
// SPDX-License-Identifier: LGPL-3.0-or-later

#include <QGuiApplication>
#include <QQmlApplicationEngine>

using namespace Qt::Literals::StringLiterals;

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationDisplayName(u"Hello TableView"_s);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("com.basyskom.tableview", "Main");

    return app.exec();
}
