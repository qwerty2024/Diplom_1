import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Window 2.5

ApplicationWindow {
    id: enterOrder
    visible: true
    width: 200
    height: 900
    title: "Выполнение заказа"

    property var status_ord

    function update_order()
    {
        status_ord = dataBase.m_curr_status_order;
    }

    Component.onCompleted:
    {
        update_order()
        console.log("Current status: " + status_ord);
    }

    // кнопка статус 1
    Button {
        id: btn_status_1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 25
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var redColor: "#ff6666" // красный цвет для status_ord < 1
            property var greenColor: "#66ff66" // зеленый цвет для status_ord >= 1

            anchors.fill: parent
            color: (status_ord < 1) ? redColor : greenColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Принять \nзаказ"      // текст кнопки
                color: btn_status_1.pressed ? "#ffffff" : "#000000"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            if (status_ord < 1)
            {
                status_ord = 1;

                dataBase.change_status_order(status_ord);
            }
            //dataBase.change_status_order();
        }
    }

    // кнопка статус 2
    Button {
        id: btn_status_2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 200
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var redColor: "#ff6666" // красный цвет для status_ord < 1
            property var greenColor: "#66ff66" // зеленый цвет для status_ord >= 1

            anchors.fill: parent
            color: (status_ord < 2) ? redColor : greenColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Ингредиенты \nподготовлены"      // текст кнопки
                color: btn_status_2.pressed ? "#ffffff" : "#000000"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            if (status_ord < 2)
            {
                status_ord = 2;

                dataBase.change_status_order(status_ord);
            }
            //dataBase.change_status_order();
        }
    }

    // кнопка статус 3
    Button {
        id: btn_status_3
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 375
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var redColor: "#ff6666" // красный цвет для status_ord < 1
            property var greenColor: "#66ff66" // зеленый цвет для status_ord >= 1

            anchors.fill: parent
            color: (status_ord < 3) ? redColor : greenColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Торт \nсобран"      // текст кнопки
                color: btn_status_3.pressed ? "#ffffff" : "#000000"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            if (status_ord < 3)
            {
                status_ord = 3;

                dataBase.change_status_order(status_ord);
            }
            //dataBase.change_status_order();
        }
    }

    // кнопка статус 4
    Button {
        id: btn_status_4
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 550
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var redColor: "#ff6666" // красный цвет для status_ord < 1
            property var greenColor: "#66ff66" // зеленый цвет для status_ord >= 1

            anchors.fill: parent
            color: (status_ord < 4) ? redColor : greenColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Торт \nдекорирован"      // текст кнопки
                color: btn_status_4.pressed ? "#ffffff" : "#000000"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            if (status_ord < 4)
            {
                status_ord = 4;

                dataBase.change_status_order(status_ord);
            }
            //dataBase.change_status_order();
        }
    }

    // кнопка статус 5
    Button {
        id: btn_status_5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 725
        width: 150
        height: 150

        background: Rectangle{      // фон кнопки
            property var redColor: "#ff6666" // красный цвет для status_ord < 1
            property var greenColor: "#66ff66" // зеленый цвет для status_ord >= 1

            anchors.fill: parent
            color: (status_ord < 5) ? redColor : greenColor

            border.color: "#01a3a4"
            radius: 5

            Text{
                text: "Торт упакован \nи готов \nк выдаче"      // текст кнопки
                color: btn_status_5.pressed ? "#ffffff" : "#000000"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            if (status_ord < 5)
            {
                status_ord = 5;

                dataBase.change_status_order(status_ord);
            }
            //dataBase.change_status_order();
        }
    }
}


