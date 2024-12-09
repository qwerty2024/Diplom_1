#include "mainwindow.h"
#include "database.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

QQmlApplicationEngine *enginePtr;

int main(int argc, char *argv[])
{
    Database dataBase; // объект базы данных, там будут все таблицы

    //qmlRegisterType<Database>("com.example", 1, 0, "MainController");

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    enginePtr = &engine;
    QQmlContext *context = engine.rootContext();

    context->setContextProperty("dataBase", &dataBase);
    engine.load(QUrl(QUrl("qrc:StartScreen.qml")));


    //engine.load(QUrl(QUrl("qrc:StartScreen.qml")));
    //if (engine.rootObjects().isEmpty())
    //{
    //    qDebug() << "crap";
    //}

    app.exec();

    //QApplication a(argc, argv);
    //MainWindow w;
    //w.show();
    //return a.exec();

    return 0;
}
