import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    PageHeader {
        id:pHeader
        width: parent.width
        anchors.top: parent.top
        title: "Screenshot Settings"
    }

    Column {
        anchors.top: pHeader.bottom
        width: parent.width

        BackgroundItem {
            id: format
            width: parent.width
            Column { anchors.fill: parent
                TextSwitch {
                    id: usePNG
                    text: "Use PNG"
                    description: "PNG images are sharper but Gallery can't easily share them"
                    checked: Shot.format == "png"
                    onCheckedChanged: Shot.format = checked? "png" : "jpg"
                }
                TextSwitch {
                    id: silent
                    text: "Silent mode"
                    description: "No tick during countdown"
                    checked: Shot.silent
                    onCheckedChanged: Shot.silent = checked
                }
            }
        }
    }
}
