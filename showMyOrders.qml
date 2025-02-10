import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Window 2.5

ApplicationWindow {
    id: recCakesWindow
    visible: true
    width: 1000
    height: 400
    title: dataBase.m_my_login

    property int rowIndex: -1

    function loadData() {
        var m_id_my_orders = dataBase.m_id_my_orders.split("@");
        var m_date_my_orders = dataBase.m_date_my_orders.split("@");
        var m_name_my_orders = dataBase.m_name_my_orders.split("@");
        var m_status_my_orders = dataBase.m_status_my_orders.split("@");

        dataModel.clear()

        for (var i = 0; i < m_id_my_orders.length; i++)
        {
            if (m_id_my_orders[i] !== "")
            {
                if (m_status_my_orders[i] === "0")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "В обработке" });
                }else if (m_status_my_orders[i] === "1")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "Принят" });
                }else if (m_status_my_orders[i] === "2")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "Подготовлены ингредиенты" });
                }else if (m_status_my_orders[i] === "3")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "Десерт собран" });
                }else if (m_status_my_orders[i] === "4")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "Десерт декорирован" });
                }else if (m_status_my_orders[i] === "5")
                {
                    dataModel.append({ id: m_id_my_orders[i], date: m_date_my_orders[i], name: m_name_my_orders[i], status: "Готов!" });
                }
            }
        }
    }

    Text{
        id: otz_ord
        text: "Мой отзыв: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 770
        anchors.topMargin: 30
        font.family: "Verdana"
        font.pixelSize: 16
    }

    Text{
        id: ocenka_ord
        text: "Моя оценка: "
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 770
        anchors.topMargin: 270
        font.family: "Verdana"
        font.pixelSize: 16
    }

    ComboBox {
        id: comboBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 770
        anchors.topMargin: 300
        width: 200
        height: 35
        font.family: "Verdana"
        font.pixelSize: 16

        model: ["Нет оценки", "1", "2", "3", "4", "5"]
        currentIndex: 0   // Устанавливаем индекс выделенного элемента
    }

    // поле ввода описания
    Rectangle {
        width: 200;
        height: 200;
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 770
        anchors.topMargin: 50

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
                        //info_cake.text = "Описание:\n " + edit.text;
                    }
                }
            }
        }
    }

    Rectangle {
        width: 760
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
                    width: 160
                    title: "Идентификатор"
                    role: "id"
                }
                TableViewColumn {
                    width: 200
                    title: "Дата"
                    role: "date"
                }
                TableViewColumn {
                    width: 220
                    title: "Название"
                    role: "name"
                }
                TableViewColumn {
                    width: 160
                    title: "Статус"
                    role: "status"
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
                                        rowIndex = styleData.row;
                                        dataBase.give_me_otz(dataModel.get(rowIndex).id)

                                        edit.text = dataBase.m_comm_order

                                        if (dataBase.m_estim_order === "")
                                            comboBox.currentIndex = 0
                                        else
                                            comboBox.currentIndex = dataBase.m_estim_order

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

    // кнопка
    Button {
        id: btn_otz
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 770
        anchors.topMargin: 350
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_otz.pressed ? pressedColor :
                   btn_otz.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Оставить отзыв!"      // текст кнопки
                color: btn_otz.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            //dataBase.order_cake(dataBase.m_curr_cake_name);
            //var rowIndex = styleData.row;
            if (rowIndex !== -1)
            {
                dataBase.set_my_otz(dataModel.get(rowIndex).id, edit.text, comboBox.currentText)
            }
        }
    }
}


