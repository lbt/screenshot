import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "pages"

ApplicationWindow
{
    id: appWindow
    initialPage: Snap { }

    cover: CoverBackground  {
        Image {
            id: icon
            y: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:///usr/share/icons/hicolor/86x86/apps/harbour-screenshot.png"
        }
        Label {
            id: label
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeTiny
            text: "lbt's"
            anchors.top : icon.bottom
            anchors.topMargin: Theme.paddingMedium
        }
        Label {
            id: label2
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Screen Shot"
            anchors.top : label.bottom
        }
        Label {
            id: take
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Taking in :"
            visible: Shot.active
            anchors.top : label2.bottom
        }
        Label {
            id: left
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeLarge
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

    // Tie some audio to the Shot signals
    Audio {
        id: shotSound
        source: "/usr/share/harbour-screenshot/shotSound.wav"
    }
    Audio {
        id: tickSound
        source: "/usr/share/harbour-screenshot/tickSound.wav"
    }
    Connections {
        target: Shot;
        onShooting: { shotSound.play(); }
        onLeftChanged: { if (Shot.left >0) tickSound.play();  }
    }
    Component.onCompleted: console.log(Shot)
}
