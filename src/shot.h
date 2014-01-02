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

    bool active();
    int left();
    void setLeft(int l);
    QString lastShot();

    Q_INVOKABLE void Shoot(int d);
    Q_INVOKABLE void Cancel();

public slots:
    void ShootNow();
    void Update();
    void emitShotDone();
    void deleteCurrent();

signals:
    void activeChanged(bool);
    void leftChanged(int);
    void shooting();
    void shotDone();
    void lastShotChanged(QString);

private:
    bool m_active;
    int m_left;
    QTimer* m_timer;
    QString m_picDir;
    QDateTime m_lastShotDT; // Time shot taken
    QString m_lastShot;    // file found near time taken
                            // null = not checked / "" not found / "val"
};

#endif // SHOT_H
