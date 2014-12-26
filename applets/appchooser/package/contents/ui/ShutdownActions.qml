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
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.pss.appchooser.private 0.1 as AppChooser
import PSS.Components 1.0

RowLayout {
    implicitWidth: (units.iconSizes.large * 3) + (spacing * 3)
    implicitHeight: units.iconSizes.large + (spacing * 2)
    spacing: units.largeSpacing

    AppChooser.SystemModel {
        id: systemModel

        function triggerAction(action) {
            plasmoid.expanding = false;
            return trigger(rowForFavoriteId(action), "", null);
        }
    }

    Controls.ToolButton {
        width: units.iconSizes.large
        height: width
        iconName: "system-log-out-symbolic"
        tooltip: i18n("Log out from current session")
        onClicked: systemModel.triggerAction("logout")
    }

    Controls.ToolButton {
        width: units.iconSizes.large
        height: width
        iconName: "system-shutdown-symbolic"
        tooltip: i18n("Power off the system")
        onClicked: systemModel.triggerAction("shutdown")
    }

    Controls.ToolButton {
        width: units.iconSizes.large
        height: width
        iconName: "system-reboot-symbolic"
        tooltip: i18n("Restart the system")
        onClicked: systemModel.triggerAction("reboot")
    }
}
