/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2013-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property string cfg_Orientation
    property alias cfg_PrimaryColor: colorButton1.color
    property alias cfg_SecondaryColor: colorButton2.color

    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            margins: units.largeSpacing
        }

        ComboBox {
            model: [
                i18nd("org.pss.wallpapers.gradient", "Horizontal"),
                i18nd("org.pss.wallpapers.gradient", "Vertical")
            ]
            onActivated: root.cfg_Orientation = index == 0 ? "horizontal" : "vertical"

            Layout.minimumWidth: units.gridUnit * 2

            Component.onCompleted: currentIndex = root.cfg_Orientation == "horizontal" ? 0 : 1
        }

        ColorButton {
            id: colorButton1

            Layout.minimumWidth: units.gridUnit * 4
        }

        ColorButton {
            id: colorButton2

            Layout.minimumWidth: units.gridUnit * 4
        }
    }
}
