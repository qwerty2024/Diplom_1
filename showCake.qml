import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Window 2.5

ApplicationWindow {
    id: recCakesWindow
    visible: true
    width: 1000
    height: 680
    title: dataBase.m_curr_cake_name

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
        //name_estim_curr.text = "Оценка: " + result;
        name_review_curr.text = "Отзывы: " + m_curr_cake_review;

        // Обновляем текстовое поле
        let ingredientList = [];

        for (let i = 0; i < ingr_for_ingr.length; i++)
        {
            if (ingr_for_ingr[i] !== "")
                ingredientList.push(ingr_for_ingr[i] + ": " + count_ingr_for_ingr[i]);
        }

        name_ingr_curr.text = "Ингредиенты:\n" + ingredientList.join("\n");

        name_pic_curr.source = "file:///" + dataBase.m_path + "/pic_cakes/" + m_curr_cake_pic + ".jpg";
    }

    Component.onCompleted:
    {
        update_show_rec_cake()

        edit.text = dataBase.m_comments_for_cake
    }

    Text{
        id: name_cake_curr
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 20
    }

    Text{
        id: name_weight_curr
        text: "Вес: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 50
    }

    Text{
        id: name_price_curr
        text: "Цена: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 80
    }

    Text{
        id: name_desc_curr
        text: "Описание: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 110
    }

    //Text{
    //    id: name_estim_curr
    //    text: "Оценка: "
    //    anchors.top: parent.top
    //    anchors.left: parent.left
    //    anchors.leftMargin: 30 // фиксированное расстояние от левой грани
    //    anchors.topMargin: 200
    //}

    Text{
        id: name_review_curr
        text: "Отзывы: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 370
    }

    Text{
        id: name_ingr_curr
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30 // фиксированное расстояние от левой грани
        anchors.topMargin: 260
    }

    Image{
        id: name_pic_curr
        width: 600
        height: 600
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 350 // фиксированное расстояние от левой грани
        anchors.topMargin: 30
        //source: "pic_cakes/cake_1.jpg"
    }

    // поле вывода отзывов
    Rectangle {
        width: 200;
        height: 200;
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.topMargin: 400

        border.color: "grey"
        border.width: 2

        Flickable {
            id: flick

            width: 190;
            height: 190;
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.topMargin: 5

            contentWidth: edit.paintedWidth
            contentHeight: edit.paintedHeight
            clip: true

            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

            TextEdit {
                id: edit
                width: flick.width
                focus: true
                wrapMode: TextEdit.Wrap
                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                Connections {
                    target: edit
                    onTextChanged: {
                        //info_cake.text = "Описание:\n " + edit.text;
                    }
                }
            }
        }
    }

    // кнопка заказать
    Button {
        id: btn_go_cake
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.topMargin: 620
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_go_cake.pressed ? pressedColor :
                   btn_go_cake.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Заказать!"      // текст кнопки
                color: btn_go_cake.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.order_cake(dataBase.m_curr_cake_name);
        }
    }
}


