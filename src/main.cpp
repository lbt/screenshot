#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QGuiApplication>

#include "shot.h"
#include "viewmanager.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    ViewManager* vm = new ViewManager(view.data(), app.data());

    Shot shot;
    view->rootContext()->setContextProperty("Shot", &shot);
    view->rootContext()->setContextProperty("ViewManager", vm);
    view->setSource(SailfishApp::pathTo("qml/main.qml"));

	// The ViewManager will handle the close/show
    vm->show();

    QObject::connect(&shot, SIGNAL(shotDone()),
                     vm, SLOT(show()));
    return app->exec();
}
