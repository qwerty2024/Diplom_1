#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlTableModel>
#include <QObject>
#include <QVector>

class Database : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(int rules READ myVariable WRITE setMyVariable NOTIFY myVariableChanged)

public:
    explicit Database(QObject *parent = 0);
    Q_INVOKABLE void registration(QString text);
    Q_INVOKABLE void authentication(QString text);
    Q_INVOKABLE void show_user_table();
    Q_INVOKABLE void show_ingr_table();
    Q_INVOKABLE void change_rule(QString login, QString status);
    Q_INVOKABLE void add_ingr(QString name, QString residue, QString expiration_date);
    Q_INVOKABLE void delete_ingr(QString name, QString residue, QString expiration_date);

    QVector<QString> parse_str(const QString &str);
    bool user_exists(const QString& login);
    int test_enter(const QString& login, const QString& pass);

    void update_user_status();
    void update_ingridients();

    void openZeroWindow();
    void openOneWindow();
    void openTwoWindow();
    void hideRegWindow(QObject *window);

public:
    QSqlDatabase db;
    QSqlQuery *query;

    // Текущие логин и пароль, которые прилетели по запросу регистрации
    QString login;
    QString pass;

    int rules = -1;
    Q_PROPERTY(int m_rules MEMBER rules)

    // Таблица логинов
    QString users = "";
    Q_PROPERTY(QString m_users MEMBER users CONSTANT)

    QString statuses = "";
    Q_PROPERTY(QString m_statuses MEMBER statuses CONSTANT)

    // Таблица ингридиентов
    QString ingredients = "";
    Q_PROPERTY(QString m_ingredients MEMBER ingredients CONSTANT)

    QString residue = "";
    Q_PROPERTY(QString m_residue MEMBER residue CONSTANT)

    QString expiration_date = "";
    Q_PROPERTY(QString m_expiration_date MEMBER expiration_date CONSTANT)



    virtual ~Database() {}

};

#endif // DATABASE_H



