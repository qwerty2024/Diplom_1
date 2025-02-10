import QtQuick 2.5
import QtQuick.Controls 2.1


ApplicationWindow {
    id: zeroWindow
    visible: true
    width: 370
    height: 380
    title: "Панель администратора (" + dataBase.m_my_login + ")"

    // кнопка для вызова нового окна и просмотра всех пользователей
    Button {
        id: btn_auth
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 25
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecff"
            property var hoveredColor: "#58e0ff"
            property var pressedColor: "#20b2ff"

            anchors.fill: parent
            color: btn_auth.pressed ? pressedColor :
                   btn_auth.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "     Таблица \nпользователей"      // текст кнопки
                color: btn_auth.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.show_user_table();
        }
    }

    // кнопка для вызова нового окна и просмотра всех достпных ингридиентов
    Button {
        id: btn_ingr
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.bottomMargin: 25
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecff"
            property var hoveredColor: "#58e0ff"
            property var pressedColor: "#20b2ff"

            anchors.fill: parent
            color: btn_ingr.pressed ? pressedColor :
                   btn_ingr.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "    Таблица \nингредиентов"      // текст кнопки
                color: btn_ingr.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.show_ingr_table();
        }
    }


    // кнопка для вызова нового окна и просмотра всех рецептов сложных ингридиентов
    Button {
        id: btn_complex_ingr
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 195
        anchors.topMargin: 25
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecff"
            property var hoveredColor: "#58e0ff"
            property var pressedColor: "#20b2ff"

            anchors.fill: parent
            color: btn_complex_ingr.pressed ? pressedColor :
                   btn_complex_ingr.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "   Сложные \nингредиенты"      // текст кнопки
                color: btn_complex_ingr.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.show_complex_ingr_table();
        }
    }


    // кнопка для вызова нового окна и просмотра всех рецептов сложных ингридиентов
    Button {
        id: btn_cakes
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 195
        anchors.bottomMargin: 25
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecff"
            property var hoveredColor: "#58e0ff"
            property var pressedColor: "#20b2ff"

            anchors.fill: parent
            color: btn_cakes.pressed ? pressedColor :
                   btn_cakes.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "  Рецепты \n десертов"      // текст кнопки
                color: btn_cakes.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.show_rec_cakes();
        }
    }
}


