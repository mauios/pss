/***************************************************************************
 *   Copyright (C) 2014 by Eike Hein <hein@kde.org>                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "containmentinterface.h"

#include <Plasma/Applet>
#include <Plasma/Containment>
#include <Plasma/Corona>

#include <QDebug>
#include <QQuickItem>

ContainmentInterface::ContainmentInterface(QObject *parent) : QObject(parent),
    m_applet(0)
{
}

ContainmentInterface::~ContainmentInterface()
{
}

void ContainmentInterface::setApplet(QObject* plasmoid)
{
    if (plasmoid) {
         m_applet = plasmoid->property("_plasma_applet").value<Plasma::Applet *>();
    }
}

bool ContainmentInterface::mayAddLauncher(ContainmentInterface::Target target, const QString &entryPath)
{
    Plasma::Containment *containment = m_applet->containment();

    if (!containment) {
        return false;
    }

    Plasma::Corona *corona = containment->corona();

    if (!corona) {
        return false;
    }

    switch (target) {
        case Desktop: {
            containment = corona->containmentForScreen(containment->screen());

            if (containment) {
                return (containment->immutability() == Plasma::Types::Mutable);
            }

            break;
        }
        case Panel: {
            if (containment->pluginInfo().pluginName() == QLatin1String("org.kde.panel"))
            {
                return (containment->immutability() == Plasma::Types::Mutable);
            }

            break;
        }
        case TaskManager: {
            if (!entryPath.isEmpty() && containment->pluginInfo().pluginName() == QLatin1String("org.kde.panel"))
            {
                const Plasma::Applet *taskManager = 0;

                foreach(const Plasma::Applet *applet, containment->applets()) {
                    if (applet->pluginInfo().pluginName() == QLatin1String("org.kde.plasma.taskmanager")) {
                        taskManager = applet;

                        break;
                    }
                }

                if (taskManager) {
                    QQuickItem* gObj = qobject_cast<QQuickItem *>(taskManager->property("_plasma_graphicObject").value<QObject *>());

                    if (!gObj || !gObj->childItems().count()) {
                        return false;
                    }

                    QQuickItem *rootItem = gObj->childItems().first();

                    QVariant ret;

                    QMetaObject::invokeMethod(rootItem, "hasLauncher", Q_RETURN_ARG(QVariant, ret),
                        Q_ARG(QVariant, QUrl::fromLocalFile(entryPath)));

                    return !ret.toBool();
                }
            }

            break;
        }
    }

    return false;
}

void ContainmentInterface::addLauncher(ContainmentInterface::Target target, const QString &entryPath)
{
    Plasma::Containment *containment = m_applet->containment();

    if (!containment) {
        return;
    }

    Plasma::Corona *corona = containment->corona();

    if (!corona) {
        return;
    }

    switch (target) {
        case Desktop: {
            containment = corona->containmentForScreen(containment->screen());

            if (!containment) {
                return;
            }

            if (containment->pluginInfo().pluginName() == QLatin1String("org.kde.plasma.folder")) {
                QQuickItem* gObj = qobject_cast<QQuickItem *>(containment->property("_plasma_graphicObject").value<QObject *>());

                if (!gObj || !gObj->childItems().count()) {
                    return;
                }

                QQuickItem *rootItem = 0;

                foreach(QQuickItem *item, gObj->childItems()) {
                    if (item->objectName() == QStringLiteral("folder")) {
                        rootItem = item;

                        break;
                    }
                }

                rootItem = gObj->childItems().at(1);

                if (rootItem) {
                    QMetaObject::invokeMethod(rootItem, "addLauncher", Q_ARG(QVariant, QUrl::fromLocalFile(entryPath)));
                }
            } else {
                containment->createApplet("org.kde.plasma.icon", QVariantList() << entryPath);
            }

            break;
        }
        case Panel: {
            if (containment->pluginInfo().pluginName() == QLatin1String("org.kde.panel"))
            {
                containment->createApplet("org.kde.plasma.icon", QVariantList() << entryPath);
            }

            break;
        }
        case TaskManager: {
            if (containment->pluginInfo().pluginName() == QLatin1String("org.kde.panel"))
            {
                const Plasma::Applet *taskManager = 0;

                foreach(const Plasma::Applet *applet, containment->applets()) {
                    if (applet->pluginInfo().pluginName() == QLatin1String("org.kde.plasma.taskmanager")) {
                        taskManager = applet;

                        break;
                    }
                }

                if (taskManager) {
                    QQuickItem* gObj = qobject_cast<QQuickItem *>(taskManager->property("_plasma_graphicObject").value<QObject *>());

                    if (!gObj || !gObj->childItems().count()) {
                        return;
                    }

                    QQuickItem *rootItem = gObj->childItems().first();

                    QMetaObject::invokeMethod(rootItem, "addLauncher", Q_ARG(QVariant, QUrl::fromLocalFile(entryPath)));
                }
            }

            break;
        }
    }
}
