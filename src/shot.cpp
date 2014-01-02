#include "shot.h"
#include <QDebug>
#include <QStringBuilder>

Shot::Shot(QObject *parent) : QObject(parent),
    m_left(0),
    m_timer(new QTimer(this)),
    m_picDir("/home/nemo/Pictures"),
    m_lastShotDT(),
    m_lastShot("")
{
    if (!QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).isEmpty()) {
        m_picDir=QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).first();
        qDebug()<< "Found pictures at " << m_picDir;
    } else {
        qDebug()<< "Fallback to pictures at " << m_picDir;
    }
    m_timer->setInterval(1000);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(Update()));
}

void Shot::ShootNow() {
    emit shooting();
    m_lastShotDT=QDateTime::currentDateTime();
    QDBusMessage reply;
    QDBusConnection bus = QDBusConnection::sessionBus();
    QDBusInterface dbus_iface("org.nemomobile.lipstick", "/org/nemomobile/lipstick/screenshot",
                              "org.nemomobile.lipstick", bus);
    reply = dbus_iface.call("saveScreenshot","");
    qDebug() << reply;
    QTimer::singleShot(200, this, SLOT(emitShotDone()));
}

// This routine calls itself using a timer until the shot appears.
void Shot::emitShotDone() {
    QString file;
    QDateTime trial = m_lastShotDT;
    // There's a chance the screenshot takes a while...
    int t=0;
    do {
        m_lastShot=m_picDir % "/" % trial.toString("yyyyMMddhhmmss") % ".png";
        if (QFile(m_lastShot).exists()) {
            emit lastShotChanged(m_lastShot);
            emit shotDone();
            qDebug()<< "Found a pic " << m_lastShot;
            return;
        }
        trial = trial.addSecs(1);
        t++;
        qDebug()<< "Looking for a pic " << t;
    } while (t<5);

    // keep trying for 5s
    if (m_lastShotDT.secsTo(QDateTime::currentDateTime()) < 5)
        QTimer::singleShot(200, this, SLOT(emitShotDone()));

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
