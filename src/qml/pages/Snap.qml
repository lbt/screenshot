import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property alias noCover: noCoverSwitch.checked

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

                text: "A screenshot will be placed in the Pictures folder and will appear in the gallery\n"+
                      "You can also use the cover to " +
                      (noCover?"":"cancel or ") + "take a screenshot"
            }
            BackgroundItem {
                width: parent.width
                height: contentItem.childrenRect.height
                TextSwitch {
                    id: noCoverSwitch
                    text: "Hide Cover"
                    description: "No cover during countdown or screenshot (but also no way to cancel screenshot)"
                }
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge
            height: buttonA.height
            Button {
                id: buttonA
                text: "2 sec delay"
                onClicked: take(2)
            }
            Button {
                text: "5 sec delay"
                onClicked: take(5)
            }
        }
    }


    // General take action
    function take(sec){
        Shot.Shoot(sec);
        appWindow.deactivate();
        if (noCover) {
            ViewManager.close();
            console.log("MainView is hidden");
        }
    }

    // Cover action
    function takeCover() {
        take(5);
    }
}
