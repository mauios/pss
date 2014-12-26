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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.1
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.pss.appchooser.private 0.1 as AppChooser

Item {
    property int mode: Qt.Vertical

    id: root

    AppChooser.ProcessRunner {
        id: processRunner

        function executeUserSettings() {
            plasmoid.expanded = false;
            runUserSettings();
        }
    }

    AppChooser.RunnerModel {
        id: runnerModel
        runners: new Array("bookmarks", "baloosearch", "services")
        onRunnersChanged: runnerView.forceLayout()
        onCountChanged: runnerView.forceLayout()
    }

    PlasmaCore.Svg {
        id: lineSvg
        imagePath: "widgets/line"
    }

    Component {
        id: horizontalView

        HorizontalView {}
    }

    Component {
        id: verticalView

        VerticalView {}
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: units.smallSpacing
        spacing: units.largeSpacing

        Header {
            Layout.fillWidth: true
        }

        Item {
            StackView {
                id: view
                anchors.fill: parent
                visible: !runnerView.visible
            }

            Controls.ScrollView {
                anchors.fill: parent
                visible: (searchField != "") && (runnerModel.count > 0)

                ListView {
                    id: runnerView
                    model: runnerModel
                    delegate: RunnerResults {
                        id: runnerMatches
                        width: runnerView.width
                    }
                }
            }

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout {
            ExclusiveGroup {
                id: modeGroup
            }

            Row {
                id: runnerColumns
                visible: false

                ToolButton {
                    checkable: true
                    checked: mode == Qt.Vertical
                    exclusiveGroup: modeGroup
                    iconName: "view-list-symbolic"
                    onClicked: switchMode(Qt.Vertical)
                }

                ToolButton {
                    checkable: true
                    checked: mode == Qt.Horizontal
                    exclusiveGroup: modeGroup
                    iconName: "view-paged-symbolic"
                    onClicked: switchMode(Qt.Horizontal)
                }
            }

            Controls.TextField {
                id: searchField
                placeholderText: i18n("Search...")
                focus: true
                clearButtonShown: true
                onTextChanged: runnerModel.query = text

                Layout.fillWidth: true
            }

            Layout.fillWidth: true
        }

        ShutdownActions {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        }
    }

    Component.onCompleted: switchMode(root.mode)

    function switchMode(orientation) {
        if (orientation == Qt.Vertical) {
            view.push(verticalView);
            root.width = units.largeSpacing * 16;
        } else {
            view.push(horizontalView);
            root.width = units.largeSpacing * 48;
        }

        // Simulate slide pnale with a very large height
        root.height = 10000;

        root.mode = orientation;
    }
}
