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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import PSS.Components 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

RowLayout {
    property alias reason: label.text

    clip: true

    Icon {
        id: icon
        iconName: "dialog-error"
        width: units.iconSizes.medium
        height: width

        Layout.alignment: Qt.AlignTop
    }

    Label {
        id: label
        color: theme.viewTextColor
        wrapMode: Text.Wrap

        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
    }
}
