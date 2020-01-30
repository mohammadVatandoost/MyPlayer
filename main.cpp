#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QDebug>
//#include <QApplication>

#include "backend.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("QT_IM_MODULE", QByteArray("freevirtualkeyboard"));

//    QGuiApplication app(argc, argv);
    QApplication app(argc, argv);
    QQuickStyle::setStyle("Material");


    BackEnd backEnd;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("BackEnd"), &backEnd);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
