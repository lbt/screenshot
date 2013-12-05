#ifndef SHOT_H
#define SHOT_H

#include <QObject>
#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>
#include <QtCore/QStringList>
#include <QtDBus/QtDBus>
#include <QTimer>

class Shot : public QObject
{
    Q_OBJECT
public:
    explicit Shot(QObject *parent = 0);

    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(int left READ left WRITE setLeft NOTIFY leftChanged)

    bool active();
    void setActive(bool a);
    int left();
    void setLeft(int l);

    Q_INVOKABLE void Shoot(int d);
    Q_INVOKABLE void Cancel();

public slots:
    void ShootNow();
    void Update();

signals:
    void activeChanged(bool);
    void leftChanged(int);
    void shooting();

private:
    bool m_active;
    int m_left;
    QTimer* m_timer;
};

#endif // SHOT_H
