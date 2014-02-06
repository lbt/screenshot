#ifndef SHOT_H
#define SHOT_H

#include <QObject>
#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>
#include <QtCore/QStringList>
#include <QtDBus/QtDBus>
#include <QTimer>
#include <QStandardPaths>

class Shot : public QObject
{
    Q_OBJECT
public:
    explicit Shot(QObject *parent = 0);

    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(int left READ left WRITE setLeft NOTIFY leftChanged)
    Q_PROPERTY(QString lastShot READ lastShot NOTIFY lastShotChanged)
    Q_PROPERTY(QString format READ format WRITE setFormat NOTIFY formatChanged)

    bool active();
    int left();
    void setLeft(int l);
    QString lastShot();

    Q_INVOKABLE void Shoot(int d);
    Q_INVOKABLE void Cancel();

    QString format() const { return m_format; }

public slots:
    void ShootNow();
    void Update();
    void emitShotDone();
    void deleteCurrent();

    void setFormat(QString arg);

signals:
    void activeChanged(bool);
    void leftChanged(int);
    void shooting();
    void shotDone();
    void lastShotChanged(QString);

    void formatChanged(QString arg);

private:
    bool m_active;
    int m_left;
    QTimer* m_timer;
    QString m_picDir;
    QString m_lastShotReq; // File requested
    QString m_lastShot;    // file found near time taken
    // null = not checked / "" not found / "val"
    QString m_format;
};

#endif // SHOT_H
