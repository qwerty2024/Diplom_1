#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlTableModel>
#include <QObject>
#include <QVector>
#include <QVariantList>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

class Database : public QObject
{
    Q_OBJECT

public:
    explicit Database(QObject *parent = 0);
    Q_INVOKABLE void registration(QString text);
    Q_INVOKABLE void authentication(QString text);
    Q_INVOKABLE void show_user_table();
    Q_INVOKABLE void show_ingr_table();
    Q_INVOKABLE void show_complex_ingr_table();
    Q_INVOKABLE void show_rec_cakes();
    Q_INVOKABLE void open_add_complex_ingr();
    Q_INVOKABLE void open_add_rec_cake();
    Q_INVOKABLE void change_rule(QString login, QString status);
    Q_INVOKABLE void add_ingr(QString name, QString residue, QString expiration_date);
    Q_INVOKABLE void delete_ingr(QString name, QString residue, QString expiration_date);

    QVector<QString> parse_str(const QString &str);
    bool user_exists(const QString& login);
    int test_enter(const QString& login, const QString& pass);

    void update_user_status();
    void update_ingridients();
    Q_INVOKABLE void update_comp_ingridients();
    Q_INVOKABLE void update_cakes();

    void openZeroWindow();
    void openOneWindow();
    void openTwoWindow();
    void hideRegWindow(QObject *window);

public:
    QString path = "";
    Q_PROPERTY(QString m_path MEMBER path CONSTANT)

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

    QString comp_ingr = "";
    Q_PROPERTY(QString m_comp_ingr MEMBER comp_ingr CONSTANT)

    QString type_comp_ingr = "";
    Q_PROPERTY(QString m_type_comp_ingr MEMBER type_comp_ingr CONSTANT)

    QString ingr_for_comp_ingr = "";
    Q_PROPERTY(QString m_ingr_for_comp_ingr MEMBER ingr_for_comp_ingr CONSTANT)

    QString count_ingr_for_comp_ingr = "";
    Q_PROPERTY(QString m_count_ingr_for_comp_ingr MEMBER count_ingr_for_comp_ingr CONSTANT)

    QString cakes = "";
    Q_PROPERTY(QString m_cakes MEMBER cakes CONSTANT)

    QString curr_cake_name = "";
    Q_PROPERTY(QString m_curr_cake_name MEMBER curr_cake_name CONSTANT)

    QString curr_cake_weight = "";
    Q_PROPERTY(QString m_curr_cake_weight MEMBER curr_cake_weight CONSTANT)

    QString curr_cake_price = "";
    Q_PROPERTY(QString m_curr_cake_price MEMBER curr_cake_price CONSTANT)

    QString curr_cake_desc = "";
    Q_PROPERTY(QString m_curr_cake_desc MEMBER curr_cake_desc CONSTANT)

    QString curr_cake_ingr = "";
    Q_PROPERTY(QString m_curr_cake_ingr MEMBER curr_cake_ingr CONSTANT)

    QString curr_cake_count = "";
    Q_PROPERTY(QString m_curr_cake_count MEMBER curr_cake_count CONSTANT)

    QString curr_cake_pic = "";
    Q_PROPERTY(QString m_curr_cake_pic MEMBER curr_cake_pic CONSTANT)

    QString curr_cake_estim = "";
    Q_PROPERTY(QString m_curr_cake_estim MEMBER curr_cake_estim CONSTANT)

    QString curr_cake_count_estim = "";
    Q_PROPERTY(QString m_curr_cake_count_estim MEMBER curr_cake_count_estim CONSTANT)

    QString curr_cake_review = "";
    Q_PROPERTY(QString m_curr_cake_review MEMBER curr_cake_review CONSTANT)

    virtual ~Database() {}

public slots:
    void add_comp_ingr(const QVariant &name, const QVariant &type, const QVariantList &ingredients, const QVariantList &counts);
    void add_rec_cake(const QVariant &name, const QVariant &description, const QVariant &cost, const QVariant &weight, const QVariant &pic, const QVariantList &comp_ingredients, const QVariantList &counts);
    void show_rec_comp_ingr(const QVariant &name);
    void show_rec_cake(const QVariant &name);

};

#endif // DATABASE_H



