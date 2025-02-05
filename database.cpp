#include "database.h"
#include "sha1.h"

#include <QMessageBox>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QSqlError>
#include <string>
#include <unordered_set>
#include <unordered_map>
#include <QDebug>
#include <QDateTime>

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

    // Создаем таблицу - Tорты
    query->exec("CREATE TABLE Cakes(id_cake INTEGER PRIMARY KEY AUTOINCREMENT, "
                                    "name VARCHAR(255) NOT NULL, "
                                    "price INTEGER NOT NULL, "
                                    "weight INTEGER NOT NULL, "
                                    "description TEXT NOT NULL, "
                                    "name_pic VARCHAR(255) NOT NULL, "
                                    "sum_estimation INTEGER, "
                                    "count_estimation INTEGER, "
                                    "review TEXT);");


    // Создаем таблицу - Рецепты
    query->exec("CREATE TABLE Recipe_cake(id_recipe INTEGER PRIMARY KEY AUTOINCREMENT, "
                                         "id_cake INTEGER NOT NULL, "
                                         "id_comp_ingr INTEGER NOT NULL, "
                                         "count INTEGER NOT NULL, "
                                         "FOREIGN KEY (id_cake) REFERENCES Cakes(id_cake), "
                                         "FOREIGN KEY (id_comp_ingr) REFERENCES Compound_ingr(id_comp_ingr));");


    // Создаем таблицу - Заказы
    query->exec("CREATE TABLE Orders(id_order INTEGER PRIMARY KEY AUTOINCREMENT, "
                                    "login VARCHAR(255) NOT NULL, "
                                    "id_cake INTEGER NOT NULL, "
                                    "date VARCHAR(255) NOT NULL, "
                                    "status SMALLINT NOT NULL DEFAULT '0', "
                                    "estimation SMALLINT, "
                                    "comment TEXT, "
                                    "id_worker VARCHAR(255), "
                                    "FOREIGN KEY (login) REFERENCES Users(login), "
                                    "FOREIGN KEY (id_cake) REFERENCES Cakes(id_cake));");


    //    // Создаем таблицу - Заказанные торты
    //    query->exec("CREATE TABLE Ordered_cake(id_ordered_cake INT PRIMARY KEY AUTO_INCREMENT, "
    //                                    "id_cake INT NOT NULL, "
    //                                    "quantity SMALLINT NOT NULL, "
    //                                    "id_order INT NOT NULL, "
    //                                    "id_worker VARCHAR(255), "
    //                                    "FOREIGN KEY (id_order) REFERENCES Orders(id_order))"
    //                                    "FOREIGN KEY (id_worker) REFERENCES Users(login));");



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

void Database::show_rec_cakes()
{
    update_cakes();

    qDebug() << "создаем окно для сложных ингредиентов";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/recCakesTable.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке recCakesTable.qml:" << component.errors();
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

void Database::open_add_rec_cake()
{
    qDebug() << "создаем окно для создания нового рецепта торта";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/recCakesAdd.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке recCakesAdd.qml:" << component.errors();
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

void Database::update_cakes()
{
    query = new QSqlQuery(db);

    cakes = "";

    if(query->exec("SELECT name FROM Cakes;"))
    {
        while (query->next())
        {
            cakes.push_back(query->value(0).toString() + '@');
        }
    }

    qDebug() << cakes;

    delete query;
}

void Database::update_cakes_and_pic()
{
    query = new QSqlQuery(db);

    cakes = "";
    pics = "";
    avg_est_cake = "";

    unordered_map<QString, pair<int, int>> um;

    if(query->exec("SELECT name,name_pic,id_cake FROM Cakes;"))
    {
        while (query->next())
        {
            cakes.push_back(query->value(0).toString() + '@');
            pics.push_back(query->value(1).toString() + '@');
            um[query->value(2).toString()] = {0, 0};
        }
    }

    qDebug() << cakes;
    qDebug() << pics;

    if(query->exec("SELECT id_cake,estimation FROM Orders;"))
    {
        while (query->next())
        {
            if (query->value(1).toString() != "")
            {
                um[query->value(0).toString()].first += query->value(1).toInt();
                um[query->value(0).toString()].second++;
            }
        }
    }

    if(query->exec("SELECT id_cake FROM Cakes;"))
    {
        while (query->next())
        {
            auto a = um[query->value(0).toString()];

            if (a.second == 0)
            {
                avg_est_cake.push_back("Нет оценок@");
            }
            else
            {
                avg_est_cake.push_back(QString::number((double)a.first / a.second) + '@');
            }
        }
    }

    delete query;
}

void Database::openZeroWindow()
{
    qDebug() << "создаем нулевое окно";

    my_login = login;

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
    my_login = login;
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

    my_login = login;

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

void Database::add_rec_cake(const QVariant &name, const QVariant &description, const QVariant &cost, const QVariant &weight, const QVariant &pic, const QVariantList &comp_ingredients, const QVariantList &counts)
{
    query = new QSqlQuery(db);

    // Добавим торт, если его нет
    query->exec("INSERT OR IGNORE INTO Cakes(name,price,weight,description,name_pic) VALUES('" + name.toString() + "'," + cost.toString() + "," + weight.toString() + ",'" + description.toString() + "','" + pic.toString() + "');");

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка1: " << error;

    int id_cake = -1;
    query->exec("SELECT id_cake FROM Cakes WHERE name = '" + name.toString() + "';");
    if (query->next())
        id_cake = query->value(0).toInt();

    //error = query->lastError().text();
    //qDebug() << "Ошибка2: " << error << id_type;

    for (int i = 0; i < comp_ingredients.size(); i++)
    {
        int id_ingr = -1;
        query->exec("SELECT id_comp_ingr FROM Compound_ingr WHERE name_comp_ingr = '" + comp_ingredients[i].toString() + "';");
        if (query->next())
            id_ingr = query->value(0).toInt();

        //qDebug() << name.toString() << QString::number(id_type) << ingredients[i].toString() << counts[i].toString();
        query->exec("INSERT INTO Recipe_cake(id_cake,id_comp_ingr,count) VALUES(" + QString::number(id_cake) + "," + QString::number(id_ingr) + "," + counts[i].toString() + ");");
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

void Database::show_rec_cake(const QVariant &name)
{
    curr_cake_name = name.toString();
    curr_cake_weight = "";
    curr_cake_price = "";
    curr_cake_desc = "";
    curr_cake_ingr = "";
    curr_cake_count = "";
    curr_cake_pic = "";
    curr_cake_estim = "";
    curr_cake_count_estim = "";
    curr_cake_review = "";

    query = new QSqlQuery(db);

    QString id_cake = "";

    if (query->exec("SELECT id_cake,price,weight,description,name_pic,sum_estimation,count_estimation,review FROM Cakes WHERE name = '" + name.toString() + "';"))
    {
        if (query->next())
        {
            id_cake = query->value(0).toString();
            curr_cake_price = query->value(1).toString();
            curr_cake_weight = query->value(2).toString();
            curr_cake_desc = query->value(3).toString();
            curr_cake_pic = query->value(4).toString();
            curr_cake_estim = query->value(5).toString();
            curr_cake_count_estim = query->value(6).toString();
            curr_cake_review = query->value(7).toString();
        }
    }

    if (query->exec("SELECT rc.count, ci.name_comp_ingr FROM Recipe_cake rc JOIN Compound_ingr ci ON rc.id_comp_ingr = ci.id_comp_ingr WHERE rc.id_cake = " + id_cake + ";"))
    {
        while (query->next())
        {
            curr_cake_count.push_back(query->value(0).toString() + '@');
            curr_cake_ingr.push_back(query->value(1).toString() + '@');
        }
    }

    qDebug() << curr_cake_name;
    qDebug() << id_cake;
    qDebug() << curr_cake_weight;
    qDebug() << curr_cake_price;
    qDebug() << curr_cake_desc;
    qDebug() << curr_cake_ingr;
    qDebug() << curr_cake_count;
    qDebug() << curr_cake_pic;
    qDebug() << curr_cake_estim;
    qDebug() << curr_cake_count_estim;
    qDebug() << curr_cake_review;

    delete query;
}

void Database::show_cake(const QVariant &name)
{
    comments_for_cake = "";

    query = new QSqlQuery(db);

    if (query->exec("SELECT login,comment FROM Orders o JOIN Cakes c ON o.id_cake = c.id_cake WHERE c.name = '" + name.toString() + "';"))
    {
        while (query->next())
        {
            comments_for_cake.push_back(query->value(0).toString() + ": " + query->value(1).toString() + "\n");
        }
    }

    delete query;

    show_rec_cake(name);

    qDebug() << "открываем окно просмотра тортика";

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/showCake.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке showCake.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::order_cake(const QVariant &name)
{
    query = new QSqlQuery(db);

    //qDebug() << name.toString();

    int id_cake = -1;
    query->exec("SELECT id_cake FROM Cakes WHERE name = '" + name.toString() + "';");
    if (query->next())
        id_cake = query->value(0).toInt();

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка при добавлении заказа id тортика: " << error;

    QDateTime now = QDateTime::currentDateTime();
    QString d = now.toString("yyyy-MM-dd HH:mm:ss");

    // Добавим торт, если его нет
    query->exec("INSERT INTO Orders(login,id_cake,date) VALUES('" + login + "'," + QString::number(id_cake) + ",'" + d + "');");

    //error = query->lastError().text();
    //qDebug() << "Ошибка при добавлении заказа: " << error;

    delete query;
}

void Database::update_orders()
{
    query = new QSqlQuery(db);

    id_orders = "";
    login_orders = "";
    date_orders = "";
    name_orders = "";
    status_orders = "";

    QString id_cake = "";

    //if (query->exec("SELECT id_cake FROM Orders;"))
    //{
    //    while (query->next())
    //    {
    //        qDebug() << query->value(0).toString();
    //    }
    //}


    if (query->exec("SELECT Orders.id_order,Orders.login,Orders.date,Cakes.name,Orders.status FROM Orders JOIN Cakes ON Orders.id_cake = Cakes.id_cake WHERE Orders.status != 6;"))
    {
        while (query->next())
        {
            id_orders.push_back(query->value(0).toString() + '@');
            login_orders.push_back(query->value(1).toString() + '@');
            date_orders.push_back(query->value(2).toString() + '@');
            name_orders.push_back(query->value(3).toString() + '@');
            status_orders.push_back(query->value(4).toString() + '@');
        }
    }

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка при обновлении заказов: " << error;

    qDebug() << id_orders;
    qDebug() << login_orders;
    qDebug() << date_orders;
    qDebug() << name_orders;
    qDebug() << status_orders;

    delete query;
}


void Database::enter_order(const QVariant &id)
{
    QString id_ord = id.toString();
    qDebug() << "принят заказ с id: " << id_ord;
    curr_id_order = id_ord;

    query = new QSqlQuery(db);

    curr_status_order = "";

    //int status = -1;
    query->exec("SELECT status FROM Orders WHERE id_order = " + id_ord + ";");
    if (query->next())
        curr_status_order = query->value(0).toString();

    qDebug() << "curr_status_order: " << curr_status_order;

    //if (curr_status_order == "0")
    //    query->exec("UPDATE Orders SET status = 1 WHERE id_order = " + id_ord + ";");

    delete query;

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/showOrderForWorker.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке showOrderForWorker.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::change_status_order(const QVariant &st)
{
    QString stat = st.toString();
    qDebug() << "изменить статус на : " << stat;

    query = new QSqlQuery(db);

    query->exec("SELECT status FROM Orders WHERE id_order = " + curr_id_order + ";");
    if (query->next())
        curr_status_order = query->value(0).toString();

    if (stat > curr_status_order)
    {
        query->exec("UPDATE Orders SET status = " + stat + ", id_worker = '" + login + "' WHERE id_order = " + curr_id_order + ";");
    }

    delete query;
}

void Database::open_my_orders()
{
    qDebug() << "открываем окно просмотра моих заказов";

    update_my_orders();

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/showMyOrders.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке showMyOrders.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::open_constructor()
{
    qDebug() << "открываем окно конструктора";

    update_my_orders();

    QQmlComponent component(enginePtr, QUrl(QStringLiteral("qrc:/showConstructor.qml")));
    QObject *window = component.create();

    if (window == nullptr) {
        qDebug() << "Ошибка при загрузке showConstructor.qml:" << component.errors();
    } else {
        // Здесь вы можете настроить это окно, если нужно
        window->setProperty("visible", true); // сделать окно видимым
    }
}

void Database::update_my_orders()
{
    query = new QSqlQuery(db);

    id_my_orders = "";
    date_my_orders = "";
    name_my_orders = "";
    status_my_orders = "";

    QString id_cake = "";

    if (query->exec("SELECT Orders.id_order,Orders.date,Cakes.name,Orders.status FROM Orders JOIN Cakes ON Orders.id_cake = Cakes.id_cake WHERE Orders.login = '" + my_login + "';"))
    {
        while (query->next())
        {
            id_my_orders.push_back(query->value(0).toString() + '@');
            date_my_orders.push_back(query->value(1).toString() + '@');
            name_my_orders.push_back(query->value(2).toString() + '@');
            status_my_orders.push_back(query->value(3).toString() + '@');
        }
    }

    QString error = query->lastError().text();
    qDebug() << "Ошибка при обновлении заказов: " << error;

    qDebug() << id_my_orders;
    qDebug() << date_my_orders;
    qDebug() << name_my_orders;
    qDebug() << status_my_orders;

    delete query;
}

void Database::give_me_otz(const QVariant &id)
{
    qDebug() << "запрос отзыва";

    estim_order = "";
    comm_order = "";

    query = new QSqlQuery(db);

    if (query->exec("SELECT Orders.estimation,Orders.comment FROM Orders WHERE Orders.id_order = '" + id.toString() + "';"))
    {
        while (query->next())
        {
            estim_order.push_back(query->value(0).toString());
            comm_order.push_back(query->value(1).toString());
        }
    }

    delete query;
}

void Database::set_my_otz(const QVariant &id, const QVariant &comm, const QVariant &estim)
{
    qDebug() << "установить отзыв и оценку";

    query = new QSqlQuery(db);

    qDebug() << id.toString();

    QString curr_status = "";
    if (query->exec("SELECT Orders.status FROM Orders WHERE Orders.id_order = " + id.toString() + ";"))
    {
        while (query->next())
        {
            curr_status.push_back(query->value(0).toString());
        }
    }

    qDebug() << "Текущий статус: " << curr_status;

    if (curr_status == "5")
    {
        query->exec("UPDATE Orders SET estimation = " + estim.toString() + ", comment = '" + comm.toString() + "' WHERE id_order = " + id.toString() + ";");
    }
    else
    {
        QMessageBox::information(qobject_cast<QWidget *> (parent()), "Внимание!", "Оставить отзыв возможно только после получения заказа!");
    }

    delete query;
}

void Database::order_my_cake(const QVariant &name, const QVariant &description, const QVariant &cost, const QVariant &weight, const QVariant &pic, const QVariantList &comp_ingredients, const QVariantList &counts)
{
    query = new QSqlQuery(db);

    // Добавим торт, если его нет
    query->exec("INSERT OR IGNORE INTO Cakes(name,price,weight,description,name_pic) VALUES('" + name.toString() + "'," + cost.toString() + "," + weight.toString() + ",'" + description.toString() + "','" + pic.toString() + "');");

    //QString error = query->lastError().text();
    //qDebug() << "Ошибка1: " << error;

    int id_cake = -1;
    query->exec("SELECT id_cake FROM Cakes WHERE name = '" + name.toString() + "';");
    if (query->next())
        id_cake = query->value(0).toInt();

    //error = query->lastError().text();
    //qDebug() << "Ошибка2: " << error << id_type;

    for (int i = 0; i < comp_ingredients.size(); i++)
    {
        int id_ingr = -1;
        query->exec("SELECT id_comp_ingr FROM Compound_ingr WHERE name_comp_ingr = '" + comp_ingredients[i].toString() + "';");
        if (query->next())
            id_ingr = query->value(0).toInt();

        //qDebug() << name.toString() << QString::number(id_type) << ingredients[i].toString() << counts[i].toString();
        query->exec("INSERT INTO Recipe_cake(id_cake,id_comp_ingr,count) VALUES(" + QString::number(id_cake) + "," + QString::number(id_ingr) + "," + counts[i].toString() + ");");
        //error = query->lastError().text();
        //qDebug() << "Ошибка: " << error;
    }

    QDateTime now = QDateTime::currentDateTime();
    QString d = now.toString("yyyy-MM-dd HH:mm:ss");

    // Добавим торт, если его нет
    query->exec("INSERT INTO Orders(login,id_cake,date) VALUES('" + login + "'," + QString::number(id_cake) + ",'" + d + "');");

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
