import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: oneWindow
    visible: true
    width: 800
    height: 600
    //title: "ЗАКАЗЧИК"

    flags: Qt.Window | Qt.FramelessWindowHint // Отключаем обрамление окна

    // основной фон
    Image{
        anchors.fill: parent
        source: "images/bkg5.jpg"
    }

    property int itemAngle: 60
    property int itemSize: 300

    property var cake_names: []
    property var cake_pic: []

    property int len: 0

    function loadData()
    {
        dataBase.update_cakes_and_pic();

        var cakes = dataBase.m_cakes.split("@");
        var pics = dataBase.m_pics.split("@");
        var estm = dataBase.m_avg_est_cake.split("@");

        console.log("AAAA: ", dataBase.m_avg_est_cake);

        dataModel.clear()

        len = cakes.length - 1;

        for (var i = 0; i < cakes.length; i++)
        {
            if (cakes[i] !== "")
                dataModel.append({ name: cakes[i], pic: "file:///" + dataBase.m_path + "/pic_cakes/" + pics[i] + ".jpg", estm: estm[i] });
        }
    }

    Component.onCompleted:
    {
        loadData()
    }



    Text {
        id: inform
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 280
        anchors.topMargin: 400
        font.pointSize: 24
    }

    Text {
        id: inform_1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 360
        anchors.topMargin: 430
        font.pointSize: 24
    }

    Text {
        id: re_text
        anchors.top: parent.top
        anchors.left: parent.left
        text: "Рейтинг: "
        anchors.leftMargin: 300
        anchors.topMargin: 445
        font.pointSize: 14
    }

    Text {
        id: estimat_text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 390
        anchors.topMargin: 445
        font.pointSize: 14
    }

    Rectangle {
        width: 800
        height: 400

        Image{
            anchors.fill: parent
            source: "images/bkg4.jpg"
        }

        ListModel {
            id: dataModel
        }

        PathView {
            id: view

            anchors.fill: parent
            model: dataModel
            pathItemCount: 6

            Component.onCompleted:
            {
                var currentIndex = view.currentIndex + 3;
                if (currentIndex >= 0)
                {
                    inform.text = model.get(currentIndex).name; // Обновляем текст в информе
                    estimat_text.text = model.get(currentIndex).estm;
                }
            }

            path: Path {
                startX: 0
                startY: height / 2

                PathPercent { value: 0.0 }
                PathAttribute { name: "z"; value: 0 }
                PathAttribute { name: "angle"; value: itemAngle }
                PathAttribute { name: "origin"; value: 0 }
                PathLine {
                    x: (view.width - itemSize + 200) / 2
                    y: view.height / 2
                }
                PathAttribute { name: "angle"; value: itemAngle }
                PathAttribute { name: "origin"; value: 0 }
                PathPercent { value: 0.49 }
                PathAttribute { name: "z"; value: 10 }


                PathLine { relativeX: 0; relativeY: 0 }

                PathAttribute { name: "angle"; value: 0 }
                PathLine {
                    x: (view.width - itemSize - 200) / 2 + itemSize
                    y: view.height / 2
                }
                PathAttribute { name: "angle"; value: 0 }
                PathPercent { value: 0.51 }

                PathLine { relativeX: 0; relativeY: 0 }

                PathAttribute { name: "z"; value: 10 }
                PathAttribute { name: "angle"; value: -itemAngle }
                PathAttribute { name: "origin"; value: itemSize }
                PathLine {
                    x: view.width
                    y: view.height / 1.5
                }
                PathPercent { value: 1 }
                PathAttribute { name: "z"; value: 0 }
                PathAttribute { name: "angle"; value: -itemAngle }
                PathAttribute { name: "origin"; value: itemSize }
            }

            delegate: Image{
                property double rotationAngle: PathView.angle
                property double rotationOrigin: PathView.origin

                id: name_pic_curr
                width: itemSize
                height: width
                z: PathView.z

                source: model.pic;

                transform: Rotation {
                    axis { x: 0; y: 1; z: 0 }
                    angle: rotationAngle
                    origin.x: rotationOrigin
                }
            }

            onCurrentIndexChanged: {
                var currentIndex = (view.currentIndex + 3) % len;
                if (currentIndex >= 0)
                {
                    inform.text = model.get(currentIndex).name; // Обновляем текст в информе
                    estimat_text.text = model.get(currentIndex).estm;
                }

                console.log("Current Index: ", currentIndex);
                console.log("Selected Name: ", model.get(currentIndex).name);
                console.log("Selected Picture: ", model.get(currentIndex).pic);
                console.log("Estimation: ", model.get(currentIndex).estm);
            }
        }
    }


    // кнопка добавить
    Button {
        id: btn_cake
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.topMargin: 480
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_cake.pressed ? pressedColor :
                   btn_cake.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            //radius: 5

            Text{
                text: "Просмотр тортика"      // текст кнопки
                color: btn_cake.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.show_cake(inform.text);
        }
    }


    // кнопка мои заказы
    Button {
        id: btn_my_orders
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: 200
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_my_orders.pressed ? pressedColor :
                   btn_my_orders.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            //radius: 5

            Text{
                text: "Мои заказы"      // текст кнопки
                color: btn_my_orders.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.open_my_orders();
        }
    }

    // кнопка конструктора
    Button {
        id: btn_construct
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 280
        anchors.topMargin: 530
        width: 240
        height: 40

        background: Rectangle{      // фон кнопки
            property var normalColor: "#c7ecee"
            property var hoveredColor: "#58e0da"
            property var pressedColor: "#20b2aa"

            anchors.fill: parent
            color: btn_construct.pressed ? pressedColor :
                   btn_construct.hovered ? hoveredColor :
                                      normalColor

            border.color: "#01a3a4"
            //radius: 5

            Text{
                text: "Конструктор дессертов"      // текст кнопки
                color: btn_construct.pressed ? "#ffffff" : "#01a3a4"            // цвет текста
                font.family: "Verdana";     // семейство шрифтов
                font.pixelSize: 18;         // размер шрифта
                anchors.centerIn: parent
            }
        }

        onClicked: {
            // обновили в базе данных
            dataBase.open_constructor();
        }
    }

    // кнопка выхода
    Button {
        id: btn_exit

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.topMargin: 10

        hoverEnabled: true
        width: 40
        height: 40

        icon.source: "images/exit.png"
        icon.color: "transparent"
        display: Button.TextBesideIcon
        icon.height: 50
        icon.width: 50

        background: Rectangle{      // фон кнопки
            property var normalColor: "#ffc7a8"
            property var hoveredColor: "#ffa575"
            property var pressedColor: "#ff8442"

            anchors.fill: parent
            color: btn_exit.pressed ? pressedColor :
                   btn_exit.hovered ? hoveredColor :
                                 normalColor

            border.color: "#ff722b"
            //radius: 5
        }

        Connections {
            target: exiter
            onClicked: Qt.callLater(Qt.quit)
        }
    }
}


