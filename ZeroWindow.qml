import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: zeroWindow
    visible: true
    width: 640
    height: 480
    title: "АДМИН"

    // кнопка для вызова нового окна и просмотра всех пользователей
    Button {
        id: btn_auth
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 75
        width: 250
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_auth.pressed ? pressedColor :
                   btn_auth.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Таблица пользователей"      // текст кнопки
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
        anchors.leftMargin: 55
        anchors.bottomMargin: 135
        width: 250
        height: 40

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
                text: "Таблица ингридиентов"      // текст кнопки
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
}


