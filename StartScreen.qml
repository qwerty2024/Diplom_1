import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.1

Window {
    id: mainWindow
    visible: true
    width: 800
    height: 600

    flags: Qt.Window | Qt.FramelessWindowHint // Отключаем обрамление окна

    // основной фон
    Image{
        anchors.fill: parent
        source: "images/bkg2.jpg"
    }


    Text {
        text: "Вход: "
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 210
        color: "#000000"//"#01a3a4"            // цвет текста
        font.family: "Verdana";     // семейство шрифтов
        font.pixelSize: 18;         // размер шрифта
    }



    // Объявляем свойства, которые будут хранить позицию зажатия курсора мыши
    property int previousX
    property int previousY

    MouseArea {
        id: topArea
        height: 5
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    MouseArea {
        id: bottomArea
        height: 5
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    MouseArea {
        id: leftArea
        width: 5
        anchors {
            top: topArea.bottom
            bottom: bottomArea.top
            left: parent.left
        }
    }

    MouseArea {
        id: rightArea
        width: 5
        anchors {
            top: topArea.bottom
            bottom: bottomArea.top
            right: parent.right
        }
    }

    // Центральная область для перемещения окна приложения
    MouseArea {
        anchors {
            top: topArea.bottom
            bottom: bottomArea.top
            left: leftArea.right
            right: rightArea.left
        }

        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            mainWindow.setX(mainWindow.x + dx)
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            mainWindow.setY(mainWindow.y + dy)
        }
    }


    // поле ввода логина
    TextField {
        id: input_login
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 165
        width: 200
        height: 35
        placeholderText: "Имя пользователя"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода пароля
    TextField {
        id: input_pass
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 125
        width: 200
        height: 35
        placeholderText: "Пароль"
        echoMode: TextInput.Password
        font.family: "Verdana"
        font.pixelSize: 16
    }





    // кнопка авторизация
    Button {
        id: btn_auth
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 80
        width: 200
        height: 35

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_auth.pressed ? pressedColor :
                   btn_auth.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            //radius: 5

            Text{
                text: "Авторизоваться"      // текст кнопки
                color: btn_auth.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.authentication(input_login.text + "@" + input_pass.text);
            if (dataBase.m_rules >= 0) mainWindow.visible = false
        }
    }


    // кнопка регистрации
    Button {
        id: btn_reg
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 35
        width: 200
        height: 35

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_reg.pressed ? pressedColor :
                   btn_reg.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            //radius: 5

            Text{
                text: "Регистрация"      // текст кнопки
                color: btn_reg.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.registration(input_login.text + "@" + input_pass.text);
        }
    }

    // кнопка выхода
    Button {
        id: btn_exit

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.topMargin: 15

        hoverEnabled: true
        width: 45
        height: 45

        icon.source: "images/exit.png"
        icon.color: "transparent"
        display: Button.TextBesideIcon
        icon.height: 50
        icon.width: 50

        background: Rectangle{      // фон кнопки
            property var normalColor: "#ffc7a8"
            property var hoveredColor: "#ffa575"
            property var pressedColor: "#ff8442"

            anchors.fill: parent
            color: btn_exit.pressed ? pressedColor :
                   btn_exit.hovered ? hoveredColor :
                                 normalColor

            border.color: "#ff722b"
            //radius: 5
        }

        Connections {
            target: exiter
            onClicked: Qt.callLater(Qt.quit)
        }
    }

}

