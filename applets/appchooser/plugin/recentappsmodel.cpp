/***************************************************************************
 *   Copyright (C) 2013-2014 by Eike Hein <hein@kde.org>                   *
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

#include "recentappsmodel.h"
#include "actionlist.h"

#include <KLocalizedString>
#include <KRun>
#include <KService>

RecentAppsModel::RecentAppsModel(QObject *parent) : AbstractModel(parent)
{
}

RecentAppsModel::~RecentAppsModel()
{
}

QVariant RecentAppsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_recentApps.count()) {
        return QVariant();
    }

    const QString storageId = m_recentApps.at(index.row());
    KService::Ptr service = KService::serviceByStorageId(storageId);

    if (!service) {
        return QVariant();
    }

    if (role == Qt::DisplayRole) {
        return service->name();
    } else if (role == Qt::DecorationRole) {
        return service->icon().isEmpty() ? QLatin1String("unknown") : service->icon();
    } else if (role == Kicker::FavoriteIdRole) {
        return QVariant("app:" + storageId);
    } else if (role == Kicker::HasActionListRole) {
        return true;
    } else if (role == Kicker::ActionListRole) {
        QVariantList actionList;

        QVariantMap forgetAction = Kicker::createActionItem(i18n("Forget Application"), "forget");
        actionList.append(forgetAction);

        return actionList;
    }

    return QVariant();
}

int RecentAppsModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_recentApps.count();
}

bool RecentAppsModel::trigger(int row, const QString &actionId, const QVariant &argument)
{
    Q_UNUSED(argument)

    if (row < 0 || row >= m_recentApps.count()) {
        return false;
    }

    const QString storageId = m_recentApps.at(row);


    if (actionId.isEmpty()) {
        KService::Ptr service = KService::serviceByStorageId(storageId);

        if (!service) {
            return false;
        }

        bool ran = KRun::run(*service, QList<QUrl>(), 0);

        if (ran) {
            addApp(storageId);
        }

        return ran;
    } else if (actionId == "forget") {
        return forgetApp(row);
    }

    return false;
}

QStringList RecentAppsModel::recentApps() const
{
    return m_recentApps;
}

void RecentAppsModel::setRecentApps(const QStringList &recentApps)
{
    if (m_recentApps != recentApps) {
        bool emitCountChanged = (m_recentApps.count() != recentApps.count());

        beginResetModel();

        m_recentApps = recentApps;

        endResetModel();

        if (emitCountChanged) {
            emit countChanged();
        }

        emit recentAppsChanged();
    }
}

void RecentAppsModel::addApp(const QString &storageId)
{
    if (storageId.isEmpty()) {
        return;
    }

    int index = m_recentApps.indexOf(storageId);

    if (index > 0) {
        beginMoveRows(QModelIndex(), index, index, QModelIndex(), 0);
        m_recentApps.move(index, 0);
        endMoveRows();
    } else if (index == -1) {
        if (m_recentApps.count() < 15) {
            beginInsertRows(QModelIndex(), 0, 0);
            m_recentApps.prepend(storageId);
            endInsertRows();
            emit countChanged();
        } else {
            beginResetModel();
            m_recentApps.prepend(storageId);
            m_recentApps.removeLast();
            endResetModel();
        }
    }

    emit recentAppsChanged();
}

bool RecentAppsModel::forgetApp(int row)
{
    if (row < 0 || row >= m_recentApps.count()) {
        return false;
    }

    beginRemoveRows(QModelIndex(), row, row);
    m_recentApps.removeAt(row);
    endRemoveRows();

    emit countChanged();

    emit recentAppsChanged();

    return false;
}
