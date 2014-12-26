/***************************************************************************
 *   Copyright (C) 2012 Aurélien Gâteau <agateau@kde.org>                  *
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

#ifndef APPSMODEL_H
#define APPSMODEL_H

#include "abstractentry.h"
#include "abstractmodel.h"

#include <KService>
#include <KServiceGroup>

class AppsModel;
class ContainmentInterface;

class QTimer;

class AppGroupEntry : public AbstractGroupEntry
{
    public:
        AppGroupEntry(KServiceGroup::Ptr group, QAbstractListModel *parentModel,
            bool flat, int appNameFormat);
};

class AppEntry : public AbstractEntry
{
    public:
        enum NameFormat {
            NameOnly = 0,
            GenericNameOnly,
            NameAndGenericName,
            GenericNameAndName
        };

        AppEntry(KService::Ptr service, NameFormat nameFormat);

        EntryType type() const { return RunnableType; }

        KService::Ptr service() const { return m_service; }

    private:
        KService::Ptr m_service;
};

class AppsModel : public AbstractModel
{
    Q_OBJECT

    Q_PROPERTY(bool flat READ flat WRITE setFlat NOTIFY flatChanged)
    Q_PROPERTY(QString entryPath READ entryPath WRITE setEntryPath NOTIFY entryPathChanged)
    Q_PROPERTY(int appNameFormat READ appNameFormat WRITE setAppNameFormat NOTIFY appNameFormatChanged)
    Q_PROPERTY(QObject* appletInterface READ appletInterface WRITE setAppletInterface);

    public:
        explicit AppsModel(const QString &entryPath = QString(), bool flat = false, QObject *parent = 0);
        ~AppsModel();

        QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

        int rowCount(const QModelIndex &parent = QModelIndex()) const;

        Q_INVOKABLE bool trigger(int row, const QString &actionId, const QVariant &argument);

        Q_INVOKABLE AbstractModel *modelForRow(int row);

        bool flat() const;
        void setFlat(bool flat);

        QString entryPath() const;
        void setEntryPath(const QString &entryPath);

        int appNameFormat() const;
        void setAppNameFormat(int format);

        QObject *appletInterface() const;
        void setAppletInterface(QObject *appletInterface);

    Q_SIGNALS:
        void refreshing() const;
        void flatChanged() const;
        void entryPathChanged() const;
        void appNameFormatChanged() const;

    protected Q_SLOTS:
        virtual void refresh();

    private Q_SLOTS:
        void checkSycocaChanges(const QStringList &changes);

    protected:
        QList<AbstractEntry *> m_entryList;

    private:
        void processServiceGroup(KServiceGroup::Ptr group);

        QString m_entryPath;
        QTimer *m_changeTimer;
        bool m_flat;
        AppEntry::NameFormat m_appNameFormat;
        bool m_sortNeeded;
        static ContainmentInterface *m_containmentInterface;
};

#endif
