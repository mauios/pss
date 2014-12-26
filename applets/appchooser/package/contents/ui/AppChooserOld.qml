/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2012-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.pss.appchooser.private 0.1 as AppChooser

Item {
    id: appChooser

    readonly property int itemSize: 128
    readonly property int numRows: 5
    readonly property int numColumns: 3
    readonly property int numItemsPerPage: numRows * numColumns
    readonly property int numPages: Math.ceil(grid.count / numItemsPerPage)
    property int currentPage: 0
    property var palette: SystemPalette {}

    onVisibleChanged: {
        currentPage = 0;
        grid.currentIndex = 0;
    }

    MouseArea {
        anchors.fill: parent
        onWheel: {
            if (wheel.angleDelta.x > 0 || wheel.angleDelta.y > 0) {
                // Go to the next page
                if (currentPage < numPages - 1) {
                    currentPage++;
                    grid.currentIndex = currentPage * numItemsPerPage + 1;
                }
            } else if (wheel.angleDelta.x < 0 || wheel.angleDelta.y < 0) {
                // Go to the next page
                if (currentPage > 0) {
                    currentPage--;
                    grid.currentIndex = currentPage * numItemsPerPage + 1;
                }
            }

            wheel.accepted = true;
        }
    }

    ColumnLayout {
        GridView {
            id: grid
            cacheBuffer: 100
            cellWidth: itemSize
            cellHeight: itemSize
            width: itemSize * numRows
            height: itemSize * numColumns
            clip: true
            snapMode: GridView.SnapOneRow
            flow: GridView.TopToBottom
            interactive: false
            preferredHighlightBegin: 0
            preferredHighlightEnd: 0
            highlightRangeMode: GridView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            model: VisualDataModel {
                id: visualModel
                model: AppChooser.AppsModel {
                    id: appsModel
                    flat: true
                    appNameFormat: 0
                    appletInterface: plasmoid
                }
                delegate: AppChooserDelegate {
                    icon: model.iconName
                    label: model.display
                    onClicked: {
                        // Dismiss the popup
                        appChooser.visible = false;

                        // Launch the application
                        appsModel.launch(VisualDataModel.itemsIndex);
                    }
                }
            }
        }

        Item {
            id: pageIndicator
            width: grid.width
            height: 20

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Repeater {
                    id: repeater
                    model: numPages
                    delegate: Rectangle {
                        width: pageIndicator.height
                        height: pageIndicator.height
                        color: currentPage === index ? palette.highlight : "#40000000"
                        radius: width
                        antialiasing: true

                        Label {
                            anchors.centerIn: parent
                            text: index + 1
                            color: "white"
                            font.pixelSize: pageIndicator.height * 0.7
                            visible: currentPage === index
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                grid.currentIndex = index * numItemsPerPage + 1;
                                currentPage = index;
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: appsModel.populate()
}
