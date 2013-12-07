TEMPLATE=app
TARGET = harbour-screenshot

# In the bright future this config line will do a lot of stuff to you
#CONFIG += sailfishapp

QT += quick qml dbus
CONFIG += link_pkgconfig
PKGCONFIG += sailfishapp

INCLUDEPATH += /usr/include/sailfishapp

TARGETPATH = /usr/bin
target.path = $$TARGETPATH

DEPLOYMENT_PATH = /usr/share/$$TARGET
qml.files = qml
qml.path = $$DEPLOYMENT_PATH

desktop.files = harbour-screenshot.desktop
desktop.path = /usr/share/applications

icon.files = harbour-screenshot.png icon-cover-shoot.png
icon.path = /usr/share/icons/hicolor/86x86/apps

sound.files = shotSound.wav tickSound.wav noSound.wav
sound.path = $$DEPLOYMENT_PATH

INSTALLS += target icon desktop qml sound

SOURCES += main.cpp \
    shot.cpp \
    viewmanager.cpp
OTHER_FILES = \
#    ../rpm/harbour-screenshot.yaml \
    ../rpm/harbour-screenshot.spec \
    qml/main.qml \
    shot.xml \
    qml/pages/Snap.qml

INCLUDEPATH += $$PWD

HEADERS += \
    shot.h \
    viewmanager.h
