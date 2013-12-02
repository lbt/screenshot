import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: appWindow
    initialPage: Snap { }

    cover: CoverBackground  {
        Label {
            id: label
            width: parent.width
            y: Theme.paddingLarge
            horizontalAlignment: Text.AlignHCenter
            text: "Screen Shot"
        }
        Label {
            id: take
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Taking in :"
            visible: Shot.active
            anchors.top : label.bottom
        }
        Label {
            id: left
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeHuge
            text: Shot.left.toString();
            visible: Shot.active
            anchors.top : take.bottom
        }

        CoverActionList
        {
            enabled: Shot.active
            CoverAction
            {
                iconSource: "image://theme/icon-cover-cancel"
                onTriggered: Shot.Cancel()
            }
        }
        CoverActionList
        {
            enabled: !Shot.active
            CoverAction
            {
                iconSource: "file:///usr/share/harbour-screenshot/qml/icon-cover-shoot.png"
                onTriggered: Shot.Shoot(5)
            }
        }
    }
}


