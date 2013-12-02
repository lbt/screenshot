#include "shot.h"
#include <QDebug>

Shot::Shot(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(Update()));
    m_left = 0;
}

void Shot::ShootNow() {
    QDBusConnection bus = QDBusConnection::sessionBus();
    QDBusInterface dbus_iface("org.nemomobile.lipstick", "/org/nemomobile/lipstick/screenshot",
                              "org.nemomobile.lipstick", bus);
    qDebug() << dbus_iface.call("saveScreenshot","");

}
void Shot::Cancel() {
    m_timer->stop();
    m_left = 0;
    emit leftChanged(m_left);
    emit activeChanged(active());
}
void Shot::Shoot(int delay) {
    if (delay <= 0) {
        m_timer->stop();
        m_left = 0;
        ShootNow();
    } else {
        m_left = delay;
        m_timer->start();
    }
    emit leftChanged(m_left);
    emit activeChanged(active());
}

void Shot::Update() {
    qDebug() << "time left " << m_left;
    m_left -= 1;
    emit leftChanged(m_left);
    if (m_left <= 0) {
        m_timer->stop();
        ShootNow();
        emit activeChanged(active());
    }
}

bool Shot::active() {
    return m_timer->isActive();
}

void Shot::setActive(bool a) {
}

int Shot::left() {
    return m_left;
}

void Shot::setLeft(int a) {
}
