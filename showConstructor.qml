import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: recCakesAddWindow
    visible: true
    width: 650
    height: 620
    title: "Конструктор дессертов"

    property var comp_ingrts: []

    property var comp_ingrts_curr: []
    property var counts: []


    function loadData() {
        dataBase.update_comp_ingridients()

        comp_ingrts = dataBase.m_comp_ingr.split("@");

        comp_ingrts.pop();
    }


    Component.onCompleted:
    {
        loadData()
    }

    Rectangle {
        width: 340
        height: 600

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 290 // фиксированное расстояние от левой грани
        anchors.topMargin: 0

        border.color: "black"
    }

    Text{
        id: name_cake
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 20
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: info_cake
        text: "Комментарий: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 50
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: comp_ingrts_text
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 280
        wrapMode: Text.WordWrap
        width: 300
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
        width: 250
        height: 35
        placeholderText: "Введите название"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_name
            onTextChanged: {
                name_cake.text = "Название: " + input_name.text;
            }
        }
    }

    Text{
        text: "Пожелания к заказу: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 60
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // поле ввода описания
    Rectangle {
        width: 250;
        height: 200;
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 90

        border.color: "black"
        border.width: 1

        Flickable {
            id: flick

            width: 240;
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

                font.family: "Verdana"
                font.pixelSize: 16

                Connections {
                    target: edit
                    onTextChanged: {
                        info_cake.text = "Описание:\n " + edit.text;
                    }
                }
            }
        }
    }

    Text{
        text: "Добавьте желаемые\nингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 355
        font.family: "Verdana"
        font.pixelSize: 16
    }

    //ComboBox {
    //    id: comboBox_1
    //    anchors.top: parent.top
    //    anchors.left: parent.left
    //    anchors.leftMargin: 25
    //    anchors.topMargin: 400
    //    width: 250
    //    height: 35
    //    font.family: "Verdana"
    //    font.pixelSize: 16
    //
    //    model: comp_ingrts
    //    currentIndex: 0 // Устанавливаем индекс по умолчанию
    //}

    ComboBox {
        id: comboBox_1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 400
        width: 250
        height: 35
        font.family: "Verdana"
        font.pixelSize: 16

        model: comp_ingrts
        currentIndex: 0 // Устанавливаем индекс по умолчанию

        popup: Popup {
              id:comboPopup
              height: 240
              width: comboBox_1.width
              padding: 1

              contentItem: ListView {
                  id:listView
                  width: comboBox_1.width
                  height: 240
                  implicitHeight: contentHeight
                  model: comboBox_1.popup.visible ? comboBox_1.delegateModel : null


                  ScrollIndicator.vertical: ScrollIndicator { }

              }

              background: Rectangle {
                 //radius: 20
                 anchors.top: parent.top
                 anchors.topMargin: -30
                 width: 250
                 height: 300
                 border.width: 1
                 border.color:"black"
              }
          }
    }

    TextField {
        id: input_count
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 450
        width: 250
        height: 35
        placeholderText: "Введите количество"
        font.family: "Verdana"
        font.pixelSize: 16
    }

    // кнопка добавить сложный ингредиент в состав торта
    Button {
        id: btn_add_comp_ingr_rec
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 500
        width: 250
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_add_comp_ingr_rec.pressed ? pressedColor :
                   btn_add_comp_ingr_rec.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Добавить ингредиент"      // текст кнопки
                color: btn_add_comp_ingr_rec.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // Проверяем, чтобы поля не были пустыми
            if (comboBox_1.currentText !== "" && input_count.text !== "") {
                // Сохраняем значения в массивы
                comp_ingrts_curr.push(comboBox_1.currentText);
                counts.push(input_count.text);

                // Обновляем текстовое поле
                let ingredientList = [];
                for (let i = 0; i < comp_ingrts_curr.length; i++) {
                    ingredientList.push(comp_ingrts_curr[i] + ": " + counts[i]);
                }
                comp_ingrts_text.text = "Ингредиенты:\n" + ingredientList.join("\n");

                // Очищаем поля ввода после сохранения
                comboBox_1.state = 0;
                comp_ingrts_curr.text = "";
            } else {
                console.warn("Пожалуйста, заполните оба поля.");
            }
        }
    }


    // кнопка добавить рецепт
    Button {
        id: btn_add_rec
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 550
        width: 250
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_add_rec.pressed ? pressedColor :
                   btn_add_rec.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Заказать!"      // текст кнопки
                color: btn_add_rec.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            //dataBase.add_rec_cake(input_name.text, edit.text, input_cost.text, input_weight.text, input_pic.text,  comp_ingrts_curr, counts);
            dataBase.order_my_cake(input_name.text, edit.text, "0", "0", "NO_PIC",  comp_ingrts_curr, counts);

            // закрыть окно
            close();
        }
    }
}


