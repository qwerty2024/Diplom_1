#include "database.h"
#include "sha1.h"

#include <QMessageBox>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include <QDebug>

extern QQmlApplicationEngine *enginePtr;

Database::Database(QObject *parent) : QObject(parent)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./all_users");
    if (db.open())
    {
        qDebug() << "Open database";
    }
    else
    {
        qDebug() << "NOT open database";
    }

    query = new QSqlQuery(db);
    query->exec("CREATE TABLE Users(login VARCHAR(255) NOT NULL PRIMARY KEY, pass VARCHAR(255) NOT NULL, status INT NOT NULL DEFAULT '1');");

    // Если таблица была только создана, нужно провирить наличие админа, если его нет, то создаем
    if(query->exec("SELECT login FROM Users WHERE login = 'root';"))
    {
        if (query->next())
        {
            qDebug() << "root exist";
        }
        else
        {
            Hash passHash = sha1("root");
            query->exec("INSERT INTO Users(login,pass,status) VALUES('root','" + passHash.toQString() + "',0);");
        }
    }

    delete query;
}

void Database::registration(QString text)
{
    //qDebug() << text;

    QVector<QString> tmp;
    tmp = parse_str(text);
    login = tmp[0];
    pass = tmp[1];

    //qDebug() << login;
    //qDebug() << pass;

    // проверка, вдруг такой пользователь уже зарегестрирован
    if (user_exists(login))
    {
        //qDebug() << "пользователь существует";
        // выкидываем окошко с ошибкой
        QMessageBox::critical(qobject_cast<QWidget *> (parent()), "Ошибка", "Такой пользователь уже зарегестрирован!");
    }
    else
    {
        //qDebug() << "пользователя НЕ существует";
        // добавляем пользователя в базу
        query = new QSqlQuery(db);
        Hash passHash = sha1(pass.toStdString());
        //qDebug() << login << " " << passHash.toQString();
        query->exec("INSERT INTO Users(login,pass,status) VALUES('" + login + "','" + passHash.toQString() + "',1);");
        //delete query;

        QMessageBox::information(qobject_cast<QWidget *> (parent()), "Ура!", "Вы успешно зарегестрированы!");
    }
}

void Database::authentication(QString text)
{
    QVector<QString> tmp;
    tmp = parse_str(text);
    login = tmp[0];
    pass = tmp[1];

    int test = test_enter(login, pass);

    // проверка, вдруг такой пользователь уже зарегестрирован
    if (test == -1)
    {
        qDebug() << "неверный логин или пароль";

        QMessageBox::critical(qobject_cast<QWidget *> (parent()), "Ошибка", "Неверный логин или пароль!");
    }
    else if (test == 0)
    {
        qDebug() << "вошел админ";
        openZeroWindow();
    }
    else if (test == 1)
    {
        qDebug() << "вошел клиент";
        openOneWindow();
    }
    else if (test == 2)
    {
        qDebug() << "вошел работник";
        openTwoWindow();
    }
}

void Database::show_user_table()
{
    // тут нужно запихать в какой-то стринг файл
    update_user_status(); // запрос в базу данных о пользователях и их статусах

    qDebug() << "создаем окно для таблицы пользователей и их статусов";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/userTable.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке userTable.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::change_rule(QString login, QString status)
{
    if (login != "root")
    {
        qDebug() << login << ": change to " << status;
        if (user_exists(login))
        {
            if (status == "Администратор")
                status = "0";
            else if (status == "Клиент")
                status = "1";
            else if(status == "Рабочий")
                status = "2";

            query = new QSqlQuery(db);
            query->exec("UPDATE Users SET status = '" + status + "' WHERE login = '" + login + "';");
            delete query;

            update_user_status();
        }
    }
}

int Database::test_enter(const QString& login, const QString& pass)
{
    //qDebug() << login << " ===";
    QString login_base = "";
    QString pass_base = "";
    QString status_base = "";
    query = new QSqlQuery(db);

    if(query->exec("SELECT login,pass,status FROM Users WHERE login = '" + login + "';"))
    {
        while (query->next())
        {
            login_base.push_back(query->value(0).toString());
            pass_base.push_back(query->value(1).toString());
            status_base.push_back(query->value(2).toString());
        }
    }

    delete query;

    Hash passHash = sha1(pass.toStdString());
    //qDebug() << login << " " << passHash.toQString();
    QString pass_test = passHash.toQString();

    if (login == login_base && pass_test == pass_base)
    {
        rules = status_base.toInt();
        qDebug() << rules;
        return status_base.toInt();
    }
    else return -1;

}

void Database::update_user_status()
{
    query = new QSqlQuery(db);

    users = "";
    statuses = "";

    if(query->exec("SELECT login,status FROM Users;"))
    {
        while (query->next())
        {
            users.push_back(query->value(0).toString() + '@');
            statuses.push_back(query->value(1).toString() + '@');
        }
    }

    delete query;
}

void Database::openZeroWindow()
{
    qDebug() << "создаем нулевое окно";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/ZeroWindow.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке ZeroWindow.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::openOneWindow()
{
    qDebug() << "создаем первое окно";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/OneWindow.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке OneWindow.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::openTwoWindow()
{
    qDebug() << "создаем второе окно";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/TwoWindow.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке TwoWindow.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::hideRegWindow(QObject *window)
{
    if (window)
    {
        window->setProperty("visible", false); // или можно использовать deleteLater() для безопасного удаления
    }
}

bool Database::user_exists(const QString& login)
{
    //qDebug() << login << " ===";
    QString result = "";
    query = new QSqlQuery(db);

    if(query->exec("SELECT login FROM Users WHERE login = '" + login + "';"))
    {
        while (query->next())
        {
            result.push_back(query->value(0).toString());
        }
    }

    delete query;

    //qDebug() << result << " <---- ";
    if (result == "")
        return false;
    else
        return true;
}

QVector<QString> Database::parse_str(const QString &str) // достаем n-ое слово из строки (разделитель пробел)
{
    QVector<QString> res;
    QString tmp = "";

    for (int i = 0; i < str.size(); ++i)
    {
        if (str[i] == '@')
        {
            res.push_back(tmp);
            tmp = "";
        }
        else
            tmp += str[i];
    }

    res.push_back(tmp);

    return res;
}
