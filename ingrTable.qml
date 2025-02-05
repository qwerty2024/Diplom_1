import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1

ApplicationWindow {
    id: ingrWindow
    visible: true
    width: 450
    height: 700
    title: "Базовые ингредиенты"

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
        width: 440
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

                headerDelegate: Item {
                    width: view.columnWidth
                    height: 40

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "lightgray"
                        border.color: "black"

                        Text {
                            anchors.centerIn: parent
                            text: styleData.value
                            font.pixelSize: 16
                        }
                    }
                }

                TableViewColumn {
                    width: 140
                    title: "Ингредиент"
                    role: "ingredients"
                }
                TableViewColumn {
                    width: 140
                    title: "Остаток"
                    role: "residue"
                }
                TableViewColumn {
                    width: 140
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
                            anchors.centerIn: parent
                            font.family: "Verdana"
                            font.pixelSize: 16
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
        anchors.leftMargin: 115
        anchors.bottomMargin: 250
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
        anchors.leftMargin: 115
        anchors.bottomMargin: 200
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
        anchors.leftMargin: 115
        anchors.bottomMargin: 150
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
        anchors.leftMargin: 115
        anchors.bottomMargin: 100
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
        anchors.leftMargin: 115
        anchors.bottomMargin: 50
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


