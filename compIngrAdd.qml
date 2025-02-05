import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: compIngrAddWindow
    visible: true
    width: 600
    height: 370
    title: "Добавить рецепт сложного ингредиента"

    // Массивы для хранения значений
    property var ingredients: []
    property var counts: []

    Rectangle {
        width: 300
        height: 350

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 290 // фиксированное расстояние от левой грани
        anchors.topMargin: 0

        border.color: "black"
    }

    Text{
        id: name_comp
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300 // фиксированное расстояние от левой грани
        anchors.topMargin: 20
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: name_type
        text: "Тип: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300 // фиксированное расстояние от левой грани
        anchors.topMargin: 50
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: ingrts
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300 // фиксированное расстояние от левой грани
        anchors.topMargin: 90
        wrapMode: Text.WordWrap
        width: 300 // фиксированная ширина текста
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода названия
    TextField {
        id: input_name
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 20
        width: 230
        height: 35
        placeholderText: "Введите название"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_name
            onTextChanged: {
                name_comp.text = "Название: " + input_name.text;
            }
        }
    }

    // поле ввода типа
    TextField {
        id: input_type
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 70
        width: 230
        height: 35
        placeholderText: "Введите тип"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_type
            onTextChanged: {
                name_type.text = "Тип: " + input_type.text;
            }
        }
    }

    // поле ввода названия базового ингр
    TextField {
        id: input_name_ingr
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 130
        width: 230
        height: 35
        placeholderText: "Ингридиент"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода количество базового ингр
    TextField {
        id: input_count_ingr
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 180
        width: 230
        height: 35
        placeholderText: "Количество ингридиента"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // кнопка добавить ингредиент в состав сложного ингредиента
    Button {
        id: btn_add_ingr_rec
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 230
        width: 230
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_add_ingr_rec.pressed ? pressedColor :
                   btn_add_ingr_rec.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Добавить ингредиент"      // текст кнопки
                color: btn_add_ingr_rec.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // Проверяем, чтобы поля не были пустыми
            if (input_name_ingr.text !== "" && input_count_ingr.text !== "") {
                // Сохраняем значения в массивы
                ingredients.push(input_name_ingr.text);
                counts.push(input_count_ingr.text);

                // Обновляем текстовое поле
                let ingredientList = [];
                for (let i = 0; i < ingredients.length; i++) {
                    ingredientList.push(ingredients[i] + ": " + counts[i]);
                }
                ingrts.text = "Ингредиенты:\n" + ingredientList.join("\n");

                // Очищаем поля ввода после сохранения
                input_name_ingr.text = "";
                input_count_ingr.text = "";
            } else {
                console.warn("Пожалуйста, заполните оба поля.");
            }
        }
    }

    // кнопка добавить составной ингредиент в книгу рецептов составных ингредиентов
    Button {
        id: btn_add_comp_ingr_final
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 280
        width: 230
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_add_comp_ingr_final.pressed ? pressedColor :
                   btn_add_comp_ingr_final.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Сохранить рецепт"      // текст кнопки
                color: btn_add_comp_ingr_final.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.add_comp_ingr(input_name.text, input_type.text, ingredients, counts);

            // закрыть окно
            close();
        }
    }
}


