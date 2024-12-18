import QtQuick 2.5
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1

ApplicationWindow {
    id: zeroWindow
    visible: true
    width: 490
    height: 760
    title: "Базовые ингридиенты"

    function loadData() {
        var m_ingredients = dataBase.m_ingredients.split("@");
        var m_residue = dataBase.m_residue.split("@");
        var m_expiration_date = dataBase.m_expiration_date.split("@");

        dataModel.clear()

        for (var i = 0; i < m_ingredients.length; i++)
        {
            if (m_ingredients[i] !== "")
                dataModel.append({ ingredients: m_ingredients[i], residue: m_residue[i], expiration_date: m_expiration_date[i] });
        }
    }


    Rectangle {
        width: 460
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

            TableView {
                id: view
                width: parent.width
                height: parent.height
                model: dataModel
                clip: true

                property real lastClickTime: 0
                property int selectedRow: -1

                TableViewColumn {
                    width: 100
                    title: "Ингредиенты"
                    role: "ingredients"
                }
                TableViewColumn {
                    width: 100
                    title: "Остаток"
                    role: "residue"
                }
                TableViewColumn {
                    width: 100
                    title: "Годен до:"
                    role: "expiration_date"
                }

                itemDelegate: Item {
                    width: view.width
                    height: 40

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: (styleData.row === view.selectedRow) ? "lightblue" : "transparent" // Подсветка выбранной строки

                        Text {
                            text: styleData.value
                            renderType: Text.NativeRendering
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (mouse.button === Qt.LeftButton) {
                                    var clickTime = new Date().getTime();
                                    if (clickTime - view.lastClickTime < 300) {
                                        // Действие при двойном нажатии
                                        input_new_name.text = model.ingredients;
                                        input_count.text = model.residue;
                                        input_expiration_date.text = model.expiration_date;
                                        view.selectedRow = styleData.row; // Установка выбранной строки
                                    }
                                    view.lastClickTime = clickTime;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // поле ввода логина
    TextField {
        id: input_new_name
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 280
        width: 200
        height: 35
        placeholderText: "Введите название"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода логина
    TextField {
        id: input_count
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 230
        width: 200
        height: 35
        placeholderText: "Количество"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода логина
    TextField {
        id: input_expiration_date
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 180
        width: 200
        height: 35
        placeholderText: "Годен до"
        font.family: "Verdana"
        font.pixelSize: 16
    }



    // кнопка добавить
    Button {
        id: btn_add_ingr
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 130
        width: 200
        height: 40

        contentItem: Rectangle {      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_add_ingr.pressed ? pressedColor :
                   btn_add_ingr.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Добавить"      // текст кнопки
                color: btn_add_ingr.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.add_ingr(input_new_name.text, input_count.text, input_expiration_date.text);

            // перерисовали таблицу
            loadData()
        }
    }

    // кнопка удаления
    Button {
        id: btn_delete_ingr
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 80
        width: 200
        height: 40

        contentItem: Rectangle {      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_delete_ingr.pressed ? pressedColor :
                   btn_delete_ingr.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Удалить"      // текст кнопки
                color: btn_delete_ingr.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.delete_ingr(input_new_name.text, input_count.text, input_expiration_date.text);

            // перерисовали таблицу
            loadData()
        }
    }
}


