#ifndef SHOT_H
#define SHOT_H

#include <QObject>
#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>
#include <QtCore/QStringList>
#include <QtDBus/QtDBus>
#include <QTimer>
#include <QStandardPaths>
#include <QSettings>

class Shot : public QObject
{
    Q_OBJECT
public:
    explicit Shot(QObject *parent = 0);
    ~Shot();

    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(int left READ left WRITE setLeft NOTIFY leftChanged)
    Q_PROPERTY(QString lastShot READ lastShot NOTIFY lastShotChanged)
    Q_PROPERTY(QString format READ format WRITE setFormat NOTIFY formatChanged)
    Q_PROPERTY(bool silent READ silent WRITE setSilent NOTIFY silentChanged)
    Q_PROPERTY(int delay READ delay WRITE setDelay NOTIFY delayChanged)

    bool active();
    int left();
    void setLeft(int l);
    QString lastShot();

    Q_INVOKABLE void Shoot(int d);
    Q_INVOKABLE void Cancel();

    QString format() const { return m_format; }
    bool silent() const { return m_silent; }
    int delay() const { return m_delay; }

public slots:
    void ShootNow();
    void Update();
    void emitShotDone();
    void deleteCurrent();

    void setFormat(QString arg);
    void setSilent(bool arg);
    void setDelay(int arg);

signals:
    void activeChanged(bool);
    void leftChanged(int);
    void shooting();
    void shotDone();
    void lastShotChanged(QString);

    void formatChanged(QString arg);
    void silentChanged(bool arg);
    void delayChanged(int arg);

private:
    bool m_active;
    int m_left;
    QTimer* m_timer;
    QString m_picDir;
    QString m_lastShotReq; // File requested
    QString m_lastShot;    // file found near time taken
    // null = not checked / "" not found / "val"
    QString m_format;
    QSettings m_settings;
    bool m_silent;
    int m_delay;
};

#endif // SHOT_H
