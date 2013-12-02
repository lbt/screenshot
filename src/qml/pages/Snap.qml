import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            id: pullDownMenu
            visible: false // Until implemented
            MenuItem {
                text: "Timer"
                onClicked: {
                    console.log("Timer picked")
                }
            }
            MenuItem {
                text: "Shake"
                onClicked: {
                    console.log("Shake picked")
                }
            }
            MenuItem {
                text: "Proximity"
                onClicked: {
                    console.log("Proximity picked")
                }
            }
        }

        Column {
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Screenshot"
            }
            Label {
                width: parent.width
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                text: "A screenshot will be placed in the Pictures folder and will appear in the gallery\nYou can also use the cover to cancel or take a screenshot"
            }

            BackgroundItem {
                width: parent.width
                height: contentItem.childrenRect.height

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: buttonA.height
                    Button {
                        id: buttonA
                        text: "2 sec delay"

                        onClicked: {
                            Shot.Shoot(2);
                            appWindow.deactivate();
                        }
                    }

                    Button {
                        text: "5 sec delay"

                        onClicked: {
                            Shot.Shoot(5);
                            appWindow.deactivate();
                        }
                    }
                }
            }
        }
    }

}


