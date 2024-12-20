import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1

ApplicationWindow {
    id: compIngrWindow
    visible: true
    width: 700
    height: 600
    title: "Рецепты сложных ингредиентов"

    function update_show_rec()
    {
        var ingr_for_comp_ingr = dataBase.m_ingr_for_comp_ingr.split("@");
        var count_ingr_for_comp_ingr = dataBase.m_count_ingr_for_comp_ingr.split("@");

        // Обновляем текстовое поле
        let ingredientList = [];

        for (let i = 0; i < ingr_for_comp_ingr.length; i++)
        {
            if (ingr_for_comp_ingr[i] !== "")
                ingredientList.push(ingr_for_comp_ingr[i] + ": " + count_ingr_for_comp_ingr[i]);
        }

        ingrts_1.text = "Ингредиенты:\n" + ingredientList.join("\n");
    }

    function loadData()
    {
        var comp_ingr = dataBase.m_comp_ingr.split("@");
        var type_comp_ingr = dataBase.m_type_comp_ingr.split("@");

        dataModel.clear()

        for (var i = 0; i < comp_ingr.length; i++)
        {
            if (comp_ingr[i] !== "")
                dataModel.append({ type: type_comp_ingr[i], name: comp_ingr[i] });
        }
    }

    Text{
        id: name_comp_1
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 20
    }

    Text{
        id: name_type_1
        text: "Тип: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 50
    }

    Text{
        id: ingrts_1
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 90
        wrapMode: Text.WordWrap
        width: 300 // фиксированная ширина текста
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

                TableViewColumn {
                    width: 200
                    title: "Тип"
                    role: "type"
                }
                TableViewColumn {
                    width: 200
                    title: "Название"
                    role: "name"
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
                                        var rowIndex = styleData.row; // Получаем индекс строки
                                        var nameValue = dataModel.get(rowIndex).name;
                                        var typeValue = dataModel.get(rowIndex).type;
                                        dataBase.show_rec_comp_ingr(nameValue);

                                        name_comp_1.text = "Название: " + nameValue;
                                        name_type_1.text = "Тип: " + typeValue;

                                        // Функция обновить дынные и записать в тексте для вывода рецепта
                                        update_show_rec();

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

    // кнопка обновить
    Button {
        id: btn_update_comp
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 85
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_update_comp.pressed ? pressedColor :
                   btn_update_comp.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Обновить"      // текст кнопки
                color: btn_update_comp.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.update_comp_ingridients();
            loadData();
        }
    }

    // кнопка добавить
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
                text: "Создать новый"      // текст кнопки
                color: btn_change_rule.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.open_add_complex_ingr();
        }
    }
}


