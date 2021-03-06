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

import QtQuick 2.0

Rectangle {
    property alias mainItem: container.children

    id: root
    color: "#88000000"
    z: 1000
    focus: visible
    visible: false

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: container
        anchors.centerIn: parent
        radius: units.largeSpacing
        z: 1001
        color: "red"
        width: Math.min(parent.width * 0.5, childrenRect.width)
        height: Math.min(parent.height * 0.5, childrenRect.height)
    }

    Keys.onEscapePressed: root.visible = false
}
