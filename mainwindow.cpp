#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDebug>
#include "sha1.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{

}

MainWindow::~MainWindow()
{
    delete ui;
}

