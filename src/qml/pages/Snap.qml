import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property alias noCover: noCoverSwitch.checked
    property alias delay: delayS.value

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
            width: parent.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Screenshot"
            }
            Column {
                width: parent.width
                Label {
                    width: parent.width - Theme.paddingLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                    text: "A screenshot will be placed in the Pictures folder and will appear in the gallery."
                }
                Label {
                    id: notes
                    width: parent.width - Theme.paddingLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                    text: "You can also use the cover to " +
                          (noCover?"":"cancel or ") + "take a screenshot"

                    Behavior on text {
                        SequentialAnimation {
                            PropertyAnimation { target: notes; properties: "opacity"; to: 0;
                                duration: 300}
                            PropertyAction { target: notes; property: "text" }
                            PropertyAnimation { target: notes; properties: "opacity"; to: 2;
                                duration: 300}
                        }
                    }
                }
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
            Slider {
                id: delayS
                width: parent.width
                value: 5
                minimumValue: 2
                maximumValue: 15
                stepSize: 1
                valueText: value + "sec"
                label: "Screenshot delay"
            }
            Label {
                width: parent.width - Theme.paddingLarge
                opacity: delay >= 5 ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Countdown tick plays for the last 5 seconds"
                Behavior on opacity {
                    PropertyAnimation { duration: 300}
                }
            }

        }
        Button {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Take in " + delay + " sec"
            onClicked: take(delay)
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
        take(delay);
    }
}
