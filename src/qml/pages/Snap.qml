import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property alias delay: delayS.value
    property alias noCover: noCoverSwitch.checked

    SilicaFlickable {
        anchors.fill: parent
        PageHeader {
            id:pHeader
            width: parent.width
            anchors.top: parent.top
            title: "Screenshot"
        }
        Column {
            id:txtCol
            anchors.top: pHeader.bottom
            width: parent.width
            Label {
                width: parent.width - Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                text: "Saves to Pictures/screenshots/ (and appears in Gallery too)"
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
                        PropertyAnimation { target: notes; properties: "opacity"; to: 1;
                            duration: 300}
                    }
                }
            }
        }
        Item { // Preview and delete button.
            id: imgItem
            anchors.top:txtCol.bottom
            anchors.bottom:hideCover.top
            anchors.topMargin: Theme.paddingMedium
            anchors.bottomMargin: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - Theme.paddingLarge
            visible: Shot.lastShot != ""
            Item {
                id: snapHalf
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width/2
                Rectangle {
                    anchors.centerIn: snapImg
                    width: snapImg.paintedWidth + (snapImgMA.pressed?16:8)
                    height: snapImg.paintedHeight + (snapImgMA.pressed?16:8)
                    color: Theme.highlightColor
                }
                Image {
                    id:snapImg
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    source: "file://"+Shot.lastShot
                    RemorseItem { id: imgRemorse }
                    MouseArea {
                        id:snapImgMA
                        anchors.centerIn: parent
                        width: parent.paintedWidth
                        height: parent.paintedHeight
                        onClicked: Qt.openUrlExternally(snapImg.source)
                    }
                }
                Item {id: snapHalfOverlay
                    anchors.fill: parent
                }
            }
            Item {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: parent.width/2
                Image {
                    anchors.centerIn: parent
                    source: "image://theme/icon-m-delete"
                    MouseArea {
                        id:snapDelMA
                        anchors.centerIn: parent
                        width: parent.paintedWidth
                        height: parent.paintedHeight
                        onClicked: {
                            imgRemorse.execute(snapHalfOverlay, "Deleting",
                                                function() { Shot.deleteCurrent(); } )
                        }
                    }
                }
            }
        }
        BackgroundItem {
            id: hideCover
            width: parent.width
            height:noCoverSwitch.height
            anchors.bottom: delayS.top
            anchors.left: parent.left
            TextSwitch {
                id: noCoverSwitch
                width: parent.width
                text: "Hide Cover"
                description: "No cover during countdown or screenshot (but also no way to cancel screenshot)"
            }
        }
        Slider {
            id: delayS
            anchors.bottom: countLabel.top
            width: parent.width
            value: Shot.delay
            minimumValue: 2
            maximumValue: 15
            stepSize: 1
            valueText: value + "sec"
            label: "Screenshot delay"
            onValueChanged: Shot.setDelay(value);
        }
        Label {
            id:countLabel
            anchors.bottom: takeButton.top
            anchors.bottomMargin: Theme.paddingMedium
            width: parent.width - Theme.paddingLarge
            opacity: delay >= 5 ? 1 : 0
            visible: opacity > 0.01 && (! Shot.silent)
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "Countdown tick for the last 5 secs"
            Behavior on opacity {
                SequentialAnimation {
                    PropertyAnimation { property: "opacity"; duration: 300}
                }
            }
        }
        Label {
            id:countLabel2
            anchors.bottom: takeButton.top
            anchors.bottomMargin: Theme.paddingMedium
            width: parent.width - Theme.paddingLarge
            visible: Shot.silent
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "No countdown tick or 'click'"
        }
        Button {
            id:takeButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Take in " + delay + " sec"
            onClicked: take(delay)
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached("Settings.qml", {});
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
