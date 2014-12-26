/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickControls
import PSS.Components 1.0

ColumnLayout {
    width: GridView.view.cellWidth
    height: GridView.view.cellHeight
    spacing: units.smallSpacing

/*
    Icon {
        id: icon
        width: units.iconSizes.large
        height: width
        iconName: model.iconName

        Layout.alignment: Qt.AlignCenter
    }
*/
    KQuickControls.QIconItem {
        id: icon
        width: units.iconSizes.large
        height: width
        icon: model.decoration

        Layout.alignment: Qt.AlignCenter
    }

    Label {
        id: label
        text: model.display
        color: PlasmaCore.ColorScope.textColor
        wrapMode: Text.Wrap
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignTop
        textFormat: Text.PlainText

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            parent.GridView.view.model.trigger(index, "", null);
            plasmoid.expanded = false;
        }
    }

    Accessible.role: Accessible.MenuItem
    Accessible.name: label.text
}
