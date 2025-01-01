import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Window 2.5

ApplicationWindow {
    id: recCakesWindow
    visible: true
    width: 800
    height: 700
    title: "Рецепты тортов"

    function update_show_rec_cake()
    {
        var m_curr_cake_weight = dataBase.m_curr_cake_weight;
        var m_curr_cake_price = dataBase.m_curr_cake_price;
        var m_curr_cake_desc = dataBase.m_curr_cake_desc;
        var ingr_for_ingr = dataBase.m_curr_cake_ingr.split("@");
        var count_ingr_for_ingr = dataBase.m_curr_cake_count.split("@");
        var m_curr_cake_pic = dataBase.m_curr_cake_pic;
        var m_curr_cake_estim = dataBase.m_curr_cake_estim;
        var m_curr_cake_count_estim = dataBase.m_curr_cake_count_estim;
        var m_curr_cake_review = dataBase.m_curr_cake_review;

        var estim = parseFloat(m_curr_cake_estim);
        var count = parseFloat(m_curr_cake_count_estim);
        var result;
        if (count !== 0) {
            result = (estim / count).toString(); // делим и преобразуем результат обратно в строку
        } else {
            result = "Оценок нет"; // обработка случая деления на ноль
        }

        name_weight_curr.text = "Вес: " + m_curr_cake_weight;
        name_price_curr.text = "Цена: " + m_curr_cake_price;
        name_desc_curr.text = "Описание: " + m_curr_cake_desc;
        name_estim_curr.text = "Оценка: " + result;
        name_review_curr.text = "Отзывы: " + m_curr_cake_review;

        // Обновляем текстовое поле
        let ingredientList = [];

        for (let i = 0; i < ingr_for_ingr.length; i++)
        {
            if (ingr_for_ingr[i] !== "")
                ingredientList.push(ingr_for_ingr[i] + ": " + count_ingr_for_ingr[i]);
        }

        name_ingr_curr.text = "Ингредиенты:\n" + ingredientList.join("\n");

//console.log("Executable Path: " + dataBase.m_path + "/pic_cakes/" + m_curr_cake_pic + ".jpg");
        name_pic_curr.source = "file:///" + dataBase.m_path + "/pic_cakes/" + m_curr_cake_pic + ".jpg";
    }

    function loadData()
    {
        var cakes = dataBase.m_cakes.split("@");

        dataModel.clear()

        for (var i = 0; i < cakes.length; i++)
        {
            if (cakes[i] !== "")
                dataModel.append({ name: cakes[i] });
        }
    }

    Component.onCompleted:
    {
        loadData()
    }

    Text{
        id: name_cake_curr
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 20
    }

    Text{
        id: name_weight_curr
        text: "Вес: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 50
    }

    Text{
        id: name_price_curr
        text: "Цена: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 80
    }

    Text{
        id: name_desc_curr
        text: "Описание: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 110
    }

    Text{
        id: name_estim_curr
        text: "Оценка: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 200
    }

    Text{
        id: name_review_curr
        text: "Отзывы: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 230
    }

    Text{
        id: name_ingr_curr
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 260
    }

    Image{
        id: name_pic_curr
        width: 300
        height: 300
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450 // фиксированное расстояние от левой грани
        anchors.topMargin: 330
        //source: "pic_cakes/cake_1.jpg"
    }

    Rectangle {
        width: 440
        height: 400

        ListModel {
            id: dataModel
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

                                        dataBase.show_rec_cake(nameValue);

                                        name_cake_curr.text = "Название: " + nameValue;

                                        // Функция обновить дынные и записать в тексте для вывода рецепта
                                        update_show_rec_cake();

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

    // кнопка добавить
    Button {
        id: btn_add_rec_cake
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
            color: btn_add_rec_cake.pressed ? pressedColor :
                   btn_add_rec_cake.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Создать новый"      // текст кнопки
                color: btn_add_rec_cake.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.open_add_rec_cake();
        }
    }
}


