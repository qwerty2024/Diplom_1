import QtQuick 2.5
import QtQuick.Controls 2.1

ApplicationWindow {
    id: oneWindow
    visible: true
    width: 1200
    height: 800
    title: "ЗАКАЗЧИК"

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

        dataModel.clear()

        len = cakes.length - 1;

        for (var i = 0; i < cakes.length; i++)
        {
            if (cakes[i] !== "")
                dataModel.append({ name: cakes[i], pic: "file:///" + dataBase.m_path + "/pic_cakes/" + pics[i] + ".jpg" });
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
        anchors.leftMargin: 450
        anchors.topMargin: 400
        font.pointSize: 24
    }

    Text {
        id: inform_1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450
        anchors.topMargin: 430
        font.pointSize: 24
    }

    Rectangle {
        width: 1200
        height: 400

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
                    x: (view.width - itemSize) / 2
                    y: view.height / 2
                }
                PathAttribute { name: "angle"; value: itemAngle }
                PathAttribute { name: "origin"; value: 0 }
                PathPercent { value: 0.49 }
                PathAttribute { name: "z"; value: 10 }


                PathLine { relativeX: 0; relativeY: 0 }

                PathAttribute { name: "angle"; value: 0 }
                PathLine {
                    x: (view.width - itemSize) / 2 + itemSize
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
                    y: view.height / 2
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
                }

                console.log("Current Index: ", currentIndex);
                console.log("Selected Name: ", model.get(currentIndex).name);
                console.log("Selected Picture: ", model.get(currentIndex).pic);
            }
        }
    }

    // кнопка добавить
    Button {
        id: btn_cake
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 450
        anchors.topMargin: 450
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
            radius: 5

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
}


