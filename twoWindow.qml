import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Window 2.5

ApplicationWindow {
    id: twoWindow
    visible: true
    width: 640
    height: 480
    title: "ПОВАР"

    property var id_curr_order

    function update_orders()
    {
        dataModel.clear()

        dataBase.update_orders();
        var id_orders = dataBase.m_id_orders.split("@");
        var login_orders = dataBase.m_login_orders.split("@");
        var date_orders = dataBase.m_date_orders.split("@");
        var name_orders = dataBase.m_name_orders.split("@");
        var status_orders = dataBase.m_status_orders.split("@");

        for (let i = 0; i < id_orders.length; i++)
        {
            if (id_orders[i] !== "")
                dataModel.append({ id_order: id_orders[i], login: login_orders[i], date: date_orders[i], name_cake: name_orders[i], status: status_orders[i] });
        }
    }

    Component.onCompleted:
    {
        update_orders()
    }

    Rectangle {
        width: 600
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
                    width: 100
                    title: "ID заказа"
                    role: "id_order"
                }

                TableViewColumn {
                    width: 100
                    title: "Заказчик"
                    role: "login"
                }

                TableViewColumn {
                    width: 140
                    title: "Дата"
                    role: "date"
                }

                TableViewColumn {
                    width: 100
                    title: "Название торта"
                    role: "name_cake"
                }

                TableViewColumn {
                    width: 100
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
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (mouse.button === Qt.LeftButton) {
                                    var clickTime = new Date().getTime();
                                    if (clickTime - view.lastClickTime < 300) {
                                        // Действие при двойном нажатии
                                        var rowIndex = styleData.row; // Получаем индекс строки
                                        id_curr_order = dataModel.get(rowIndex).id_order;

                                        //dataBase.show_rec_cake(nameValue);

                                        //name_cake_curr.text = "Название: " + nameValue;

                                        // Функция обновить дынные и записать в тексте для вывода рецепта
                                        //update_show_rec_cake();

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

    // кнопка принять заказ
    Button {
        id: btn_enter_order
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.bottomMargin: 30
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_enter_order.pressed ? pressedColor :
                   btn_enter_order.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Принять заказ"      // текст кнопки
                color: btn_enter_order.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            dataBase.enter_order(id_curr_order);
        }
    }

    // кнопка принять заказ
    Button {
        id: btn_upd
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 355
        anchors.bottomMargin: 30
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_upd.pressed ? pressedColor :
                   btn_upd.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Обновить"      // текст кнопки
                color: btn_upd.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            update_orders()
        }
    }

}


