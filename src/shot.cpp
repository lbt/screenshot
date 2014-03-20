#include "shot.h"
#include <QDebug>
#include <QStringBuilder>
#include <QDir>

Shot::Shot(QObject *parent) : QObject(parent)
  , m_left(0)
  , m_timer(new QTimer(this))
  , m_lastShotReq("")
  , m_lastShot("")
  , m_settings(QDir(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation))
               .filePath(QCoreApplication::applicationName())+"/screenshot.ini",
               QSettings::IniFormat)
{
    if (!QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).isEmpty()) {
        m_picDir=QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).first();
        if (QDir().mkpath(m_picDir+"/screenshots")) {
            m_picDir+="/screenshots";
        }
        qDebug()<< "Found pictures at " << m_picDir;
    }
    qDebug()<< "Settings stored in " << m_settings.fileName();

    m_silent = m_settings.value("silent", false).toBool();
    m_format = m_settings.value("format", "jpg").toString();
    m_delay = m_settings.value("delay", 5).toInt();

    m_timer->setInterval(1000);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(Update()));
}

Shot::~Shot()
{
    qDebug()<< "Settings storing";
    qDebug()<< "Settings stored";
}

void Shot::ShootNow() {
    emit shooting();
    m_lastShotReq = m_picDir % "/"
            % QDateTime::currentDateTime().toString("yyyyMMddhhmmss") % "." % m_format;
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

void Shot::setFormat(QString arg)
{
    if (m_format != arg) {
        m_format = arg;
        m_settings.setValue("format", m_format);
        emit formatChanged(arg);
    }
}

void Shot::setSilent(bool arg)
{
    if (m_silent != arg) {
        m_silent = arg;
        m_settings.setValue("silent", m_silent);
        emit silentChanged(arg);
    }
}

void Shot::setDelay(int arg)
{
    if (m_delay != arg) {
        m_delay = arg;
        m_settings.setValue("delay", m_delay);
        emit delayChanged(arg);
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
    Q_UNUSED(a)
}
