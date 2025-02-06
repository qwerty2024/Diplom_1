import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: recCakesAddWindow
    visible: true
    width: 600
    height: 720
    title: "Добавить новый рецепт дессерта"

    property var comp_ingrts: []
    //property ListModel ingredientsModel: ListModel {}

    property var comp_ingrts_curr: []
    property var counts: []


    function loadData() {
        dataBase.update_comp_ingridients()

        comp_ingrts = dataBase.m_comp_ingr.split("@");

        comp_ingrts.pop();

        // Очищаем модель перед заполнением
        //ingredientsModel.clear();

        // Заполняем ListModel элементами из comp_ingrts
        //for (var i = 0; i < comp_ingrts.length; i++) {
        //    ingredientsModel.append({"ingredient": comp_ingrts[i]});
        //}

        //for (var i = 0; i < comp_ingrts.length; i++)
        //{
        //    console.log(comp_ingrts[i]);
        //}
    }


    Component.onCompleted:
    {
        loadData()
    }

    Rectangle {
        width: 300
        height: 680

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 285 // фиксированное расстояние от левой грани
        anchors.topMargin: 20

        border.color: "black"
    }

    Text{
        text: "Описание дессерта: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 70
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: name_cake
        text: "Название: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 25
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: info_cake
        text: "Описание: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 55
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: cost_cake
        text: "Цена: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 355
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: weight_cake
        text: "Вес: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 395
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: pic_cake
        text: "Картинка: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 435
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: comp_ingrts_text
        text: "Ингредиенты: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 485
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

    // стоимость
    TextField {
        id: input_cost
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 300
        width: 250
        height: 35
        placeholderText: "Введите стоимость"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_cost
            onTextChanged: {
                cost_cake.text = "Цена: " + input_cost.text;
            }
        }
    }

    TextField {
        id: input_weight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 350
        width: 250
        height: 35
        placeholderText: "Введите вес"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_weight
            onTextChanged: {
                weight_cake.text = "Вес: " + input_weight.text;
            }
        }
    }

    TextField {
        id: input_pic
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 390
        width: 250
        height: 35
        placeholderText: "Название картинки"
        font.family: "Verdana"
        font.pixelSize: 16

        Connections {
            target: input_pic
            onTextChanged: {
                pic_cake.text = "Картинка: " + input_pic.text;
            }
        }
    }

    ComboBox {
        id: comboBox_1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 440
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
        anchors.topMargin: 490
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
        anchors.topMargin: 540
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
        anchors.topMargin: 590
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
                text: "Сохранить рецепт"      // текст кнопки
                color: btn_add_rec.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.add_rec_cake(input_name.text, edit.text, input_cost.text, input_weight.text, input_pic.text,  comp_ingrts_curr, counts);

            // закрыть окно
            close();
        }
    }
}


