#include "shot.h"
#include <QDebug>
#include <QStringBuilder>
#include <QDir>

Shot::Shot(QObject *parent) : QObject(parent),
    m_left(0),
    m_timer(new QTimer(this)),
    m_lastShotReq(""),
    m_lastShot("")
{
    if (!QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).isEmpty()) {
        m_picDir=QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).first();
        if (QDir().mkpath(m_picDir+"/screenshots")) {
            m_picDir+="/screenshots";
        }
        qDebug()<< "Found pictures at " << m_picDir;
    } else {
        m_picDir = QString("/home/") + "nemo/Pictures/screenshots"; // Harbour complains about the fallback path :/
        qDebug()<< "Fallback to pictures at " << m_picDir;
    }
    m_timer->setInterval(1000);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(Update()));
}

void Shot::ShootNow() {
    emit shooting();
    m_lastShotReq = m_picDir % "/"
            % QDateTime::currentDateTime().toString("yyyyMMddhhmmss") % ".jpg";
    QDBusMessage reply;
    QDBusConnection bus = QDBusConnection::sessionBus();
    QDBusInterface dbus_iface("org.nemomobile.lipstick", "/org/nemomobile/lipstick/screenshot",
                              "org.nemomobile.lipstick", bus);
    reply = dbus_iface.call("saveScreenshot",m_lastShotReq);
    qDebug() << reply;
    QTimer::singleShot(200, this, SLOT(emitShotDone()));
}

// This routine calls itself using a timer until the shot appears.
void Shot::emitShotDone() {
    if (QFile(m_lastShotReq).exists()) {
        m_lastShot = m_lastShotReq;
        emit lastShotChanged(m_lastShot);
        emit shotDone();
        qDebug()<< "Found a pic " << m_lastShot;
        return;
    }
    m_lastShot="";
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
void Shot::deleteCurrent() {
    QFile curr(m_lastShot);
    if ( curr.exists() ) {
        curr.remove();
        m_lastShot="";
        emit lastShotChanged(m_lastShot);
    }
}

QString Shot::lastShot() {
    return m_lastShot;
}

bool Shot::active() {
    return m_timer->isActive();
}

int Shot::left() {
    return m_left;
}

void Shot::setLeft(int a) {
}
