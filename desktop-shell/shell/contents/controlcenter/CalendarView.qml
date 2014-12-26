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
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property alias selectedDate: calendar.selectedDate

    height: units.gridUnit * 10

    Component {
        id: hourDelegate

        Item {
            height: units.gridUnit * 2

            PlasmaComponents.Label {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: units.smallSpacing
                font: theme.smallestFont
                text: modelData + ":00"
            }

            Rectangle {
                anchors.bottom: parent.bottom
                color: PlasmaCore.ColorScope.textColor
                opacity: 0.4
                height: 1
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: units.smallSpacing
        spacing: units.largeSpacing

        Controls.Calendar {
            id: calendar
            width: units.gridUnit * 18
            height: units.gridUnit * 10
            weekNumbersVisible: true

            Layout.fillHeight: true
        }

        Controls.ScrollView {
            ListView {
                model: 25
                delegate: hourDelegate
            }

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
