import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: userWindow
    visible: true
    width: 360
    height: 580
    title: "Все пользователи"

    function loadData() {
        var users = dataBase.m_users.split("@");
        var status = dataBase.m_statuses.split("@");

        dataModel.clear()

        var adm = [];
        var cln = [];
        var wor = [];

        for (var i = 0; i < users.length; i++)
        {
            if (users[i] !== "")
            {
                if (status[i] === "0")
                    adm.push(users[i]);
                else if (status[i] === "1")
                    cln.push(users[i]);
                else if (status[i] === "2")
                    wor.push(users[i]);
            }
        }

        for (i = 0; i < adm.length; i++)
        {
            dataModel.append({ type: "Администраторы", text: adm[i] });
        }

        for (i = 0; i < wor.length; i++)
        {
            dataModel.append({ type: "Рабочие", text: wor[i] });
        }

        for (i = 0; i < cln.length; i++)
        {
            dataModel.append({ type: "Клиенты", text: cln[i] });
        }
    }


    Rectangle {
        width: 360
        height: 400

        ListModel {
            id: dataModel
        }

        Component.onCompleted:
        {
            loadData()
        }

        Column {
            anchors.margins: 10
            anchors.fill: parent
            spacing: 10

            ListView {
                id: view
                width: parent.width
                height: parent.height //- button.height - parent.spacing
                spacing: 3
                model: dataModel
                clip: true

                ScrollBar.vertical: vbar

                ScrollBar {
                    id: vbar
                    active: true
                    orientation: Qt.Vertical
                    size: view.height / view.contentHeight
                    //position: view.currentItem
                    policy: ScrollBar.AlwaysOn
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }

                section.property: "type"
                section.delegate: Rectangle {
                    width: view.width - 10
                    height: 40
                    color: "lightgreen"
                    Text {
                        anchors.centerIn: parent
                        renderType: Text.NativeRendering
                        font.bold: true
                        text: section
                        font.family: "Verdana"
                        font.pixelSize: 16
                    }
                }

                delegate: Rectangle {
                    width: view.width - 10
                    height: 40
                    border {
                        color: "black"
                        width: 1
                    }

                    Text {
                        anchors.centerIn: parent
                        renderType: Text.NativeRendering
                        text: model.text
                        font.family: "Verdana"
                        font.pixelSize: 16
                    }
                }
            }
        }
    }

    // поле ввода логина
    TextField {
        id: input_login_change
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 125
        width: 200
        height: 35
        placeholderText: "Введите логин"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода статуса
    ComboBox {
        id: comboBox
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 85
        width: 200
        height: 35
        font.family: "Verdana"
        font.pixelSize: 16

        model: ["Администратор", "Рабочий", "Клиент"]
        currentIndex: 2   // Устанавливаем индекс выделенного элемента
    }

    // кнопка изменения
    Button {
        id: btn_change_rule
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 25
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_change_rule.pressed ? pressedColor :
                   btn_change_rule.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Изменить роль"      // текст кнопки
                color: btn_change_rule.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.change_rule(input_login_change.text, comboBox.currentText);

            // перерисовали таблицу с пользователями
            loadData()
        }
    }
}


