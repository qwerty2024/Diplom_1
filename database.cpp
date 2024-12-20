#include "database.h"
#include "sha1.h"

#include <QMessageBox>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QSqlError>
#include <string>
#include <unordered_set>
#include <QDebug>

extern QQmlApplicationEngine *enginePtr;

std::string variantToString(const QVariant &variant)
{
    QString qString = variant.toString();
    return qString.toStdString();
}

Database::Database(QObject *parent) : QObject(parent)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./DATABASE");
    if (db.open())
    {
        qDebug() << "Open database";
    }
    else
    {
        qDebug() << "NOT open database";
    }

    query = new QSqlQuery(db);
    query->exec("CREATE TABLE Users(login VARCHAR(255) NOT NULL PRIMARY KEY UNIQUE, "
                                    "pass VARCHAR(255) NOT NULL, "
                                    "status SMALLINT NOT NULL DEFAULT '1');");

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


//    // Создаем таблицу - Заказы
//    query->exec("CREATE TABLE Orders(id_order INT PRIMARY KEY AUTO_INCREMENT, "
//                                    "login VARCHAR(255) NOT NULL, "
//                                    "date VARCHAR(255) NOT NULL, "
//                                    "status SMALLINT NOT NULL DEFAULT '0', "
//                                    "estimation SMALLINT, "
//                                    "comment TEXT, "
//                                    "FOREIGN KEY (login) REFERENCES Users(login));");
//
//

//
//
//    // Создаем таблицу - Заказанные торты
//    query->exec("CREATE TABLE Ordered_cake(id_ordered_cake INT PRIMARY KEY AUTO_INCREMENT, "
//                                    "id_cake INT NOT NULL, "
//                                    "quantity SMALLINT NOT NULL, "
//                                    "id_order INT NOT NULL, "
//                                    "id_worker VARCHAR(255), "
//                                    "FOREIGN KEY (id_order) REFERENCES Orders(id_order))"
//                                    "FOREIGN KEY (id_worker) REFERENCES Users(login));");
//
//


    // Создаем таблицу - Тип сложного ингридиента
    query->exec("CREATE TABLE Type_comp_ingr(id_type INTEGER PRIMARY KEY AUTOINCREMENT, "
                                            "name VARCHAR(255) NOT NULL);");


    // Создаем таблицу - Сложные ингридиенты (рецепты)
    query->exec("CREATE TABLE Compound_ingr(id_comp_ingr INTEGER PRIMARY KEY AUTOINCREMENT, "
                                            "name_comp_ingr VARCHAR(255) NOT NULL, "
                                            "id_type INTEGER NOT NULL, "
                                            "name_ingr VARCHAR(255) NOT NULL, "
                                            "count INTEGER NOT NULL, "
                                            "FOREIGN KEY (id_type) REFERENCES Type_comp_ingr(id_type));");


    // Создаем таблицу - Ингридиенты
    query->exec("CREATE TABLE Ingredients(id_ingr INTEGER PRIMARY KEY AUTOINCREMENT, "
                                         "name VARCHAR(255) NOT NULL, "
                                         "residue INTEGER NOT NULL, "
                                         "data VARCHAR(255) NOT NULL);");

    //    // Создаем таблицу - Рецепты
    //    query->exec("CREATE TABLE Recipe(id_recipe INT PRIMARY KEY AUTO_INCREMENT, "
    //                                    "id_cake INT NOT NULL, "
    //                                    "id_comp_ingr INT NOT NULL, "
    //                                    "amount SMALLINT NOT NULL, "
    //                                    "FOREIGN KEY (id_cake) REFERENCES Cakes(id_cake))"
    //                                    "FOREIGN KEY (id_comp_ingr) REFERENCES Compound_ingr(id_comp_ingr));");
    //

    //    // Создаем таблицу - Tорты
    //    query->exec("CREATE TABLE Cakes(id_cake INT PRIMARY KEY AUTO_INCREMENT, "
    //                                    "name VARCHAR(255) NOT NULL, "
    //                                    "price INT NOT NULL, "
    //                                    "weight SMALLINT NOT NULL, "
    //                                    "description TEXT, "
    //                                    "name_pic VARCHAR(255) NOT NULL, "
    //                                    "estimation SMALLINT NOT NULL, "
    //                                    "review TEXT);");


    //QString error = query->lastError().text();
    //qDebug() << "Ошибка: " << error;

    //query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('Мука',10000,'12.12.24');");
    //query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('Яйца',500,'15.04.25');");
    //query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('Соль',500,'25.04.26');");
    //query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('Фасоль',12300,'25.04.27');");
    //query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('Перец',5030,'25.04.27');");

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

void Database::show_ingr_table()
{
    update_ingridients();

    qDebug() << "создаем окно для таблицы ингредиентов";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/ingrTable.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке ingrTable.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::show_complex_ingr_table()
{
    update_comp_ingridients();

    qDebug() << "создаем окно для сложных ингредиентов";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/compIngrTable.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке compIingrTable.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::open_add_complex_ingr()
{
    qDebug() << "создаем окно для создания нового сложного ингредиента";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/compIngrAdd.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке compIngrAdd.qml:" << component.errors();
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

void Database::add_ingr(QString name, QString residue, QString expiration_date)
{
    query = new QSqlQuery(db);

    if(query->exec("SELECT residue FROM Ingredients WHERE name = '" + name + "' AND data = '" + expiration_date + "';"))
    {
        if (query->next())
        {
            qDebug() << "ЕСТЬ";
            int tmp = query->value(0).toInt() + residue.toInt();
            qDebug() << tmp;
            query->exec("UPDATE Ingredients SET residue = '" + QString::number(tmp) + "' WHERE name = '" + name + "' AND data = '" + expiration_date + "';");
        }
        else
        {
            qDebug() << "НЕТУ";
            query->exec("INSERT INTO Ingredients(name,residue,data) VALUES('" + name + "'," + residue + ",'" + expiration_date + "');");
        }
    }

    delete query;

    update_ingridients();
}

void Database::delete_ingr(QString name, QString residue, QString expiration_date)
{
    query = new QSqlQuery(db);

    if(query->exec("SELECT residue FROM Ingredients WHERE name = '" + name + "' AND data = '" + expiration_date + "';"))
    {
        if (query->next())
        {
            int tmp = query->value(0).toInt() - residue.toInt();

            if (tmp <= 0)
            {
                qDebug() << "Удаляем строку: " << name << expiration_date;
                query->exec("DELETE FROM Ingredients WHERE name = '" + name + "' AND data = '" + expiration_date + "';");
            }
            else
            {
                qDebug() << "Удаляем немного ингредиентов из: " << name << expiration_date;
                query->exec("UPDATE Ingredients SET residue = '" + QString::number(tmp) + "' WHERE name = '" + name + "' AND data = '" + expiration_date + "';");
            }
        }
        else
        {
            qDebug() << "Нет такого ингредиента";
        }
    }

    delete query;

    update_ingridients();
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

void Database::update_ingridients()
{
    query = new QSqlQuery(db);

    ingredients = "";
    residue = "";
    expiration_date = "";

    if(query->exec("SELECT name,residue,data FROM Ingredients;"))
    {
        while (query->next())
        {
            ingredients.push_back(query->value(0).toString() + '@');
            residue.push_back(query->value(1).toString() + '@');
            expiration_date.push_back(query->value(2).toString() + '@');
        }
    }

    //qDebug() << ingredients << residue << expiration_date;

    delete query;
}

void Database::update_comp_ingridients()
{
    query = new QSqlQuery(db);

    comp_ingr = "";
    type_comp_ingr = "";

    std::unordered_set<std::string> us;

    if(query->exec("SELECT Compound_ingr.name_comp_ingr,Type_comp_ingr.name FROM Compound_ingr JOIN Type_comp_ingr ON Compound_ingr.id_type = Type_comp_ingr.id_type;"))
    {
        while (query->next())
        {
            std::string name = variantToString(query->value(0));
            //qDebug() << QString::fromStdString(name);
            if (us.find(name) == us.end())
            {
                us.insert(name);
                comp_ingr.push_back(query->value(0).toString() + '@');
                type_comp_ingr.push_back(query->value(1).toString() + '@');
            }

        }
    }

    qDebug() << comp_ingr;
    qDebug() << type_comp_ingr;

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

void Database::add_comp_ingr(const QVariant &name, const QVariant &type, const QVariantList &ingredients, const QVariantList &counts)
{
    //qDebug() << "Name:" << name;
    //qDebug() << "Type:" << type;
    //qDebug() << "Ingredients:" << ingredients;
    //qDebug() << "Counts:" << counts;
    query = new QSqlQuery(db);


    // Добавим тип, если его нет
    query->exec("INSERT OR IGNORE INTO Type_comp_ingr(name) VALUES('" + type.toString() + "');");

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка1: " << error;

    int id_type = -1;
    query->exec("SELECT id_type FROM Type_comp_ingr WHERE name = '" + type.toString() + "';");
    if (query->next())
        id_type = query->value(0).toInt();

    //error = query->lastError().text();
    //qDebug() << "Ошибка2: " << error << id_type;

    for (int i = 0; i < ingredients.size(); i++)
    {
        //qDebug() << name.toString() << QString::number(id_type) << ingredients[i].toString() << counts[i].toString();
        query->exec("INSERT INTO Compound_ingr(name_comp_ingr,id_type,name_ingr,count) VALUES('" + name.toString() + "'," + QString::number(id_type) + ",'" + ingredients[i].toString() + "'," + counts[i].toString() + ");");
        //error = query->lastError().text();
        //qDebug() << "Ошибка: " << error;
    }

    delete query;
}

void Database::show_rec_comp_ingr(const QVariant &name)
{
    query = new QSqlQuery(db);

    ingr_for_comp_ingr = "";
    count_ingr_for_comp_ingr = "";

    if (query->exec("SELECT name_ingr,count FROM Compound_ingr WHERE name_comp_ingr = '" + name.toString() + "';"))
    {
        while (query->next())
        {
            ingr_for_comp_ingr.push_back(query->value(0).toString() + '@');
            count_ingr_for_comp_ingr.push_back(query->value(1).toString() + '@');
        }
    }

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка1: " << error;
    //
    //qDebug() << ingr_for_comp_ingr << count_ingr_for_comp_ingr;

    delete query;
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
