#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <iostream>
#include "srtparser.h"
#include <fstream>

using namespace std;

class BackEnd : public QObject
{
    Q_OBJECT
public:
    explicit BackEnd(QObject *parent = nullptr);
    vector<SubtitleItem*> sub;
    Q_INVOKABLE void readSubtitleFile(QString directory);
    Q_INVOKABLE QString getSubtitleText(double playTime);
    Q_INVOKABLE void chooseFile(QString directory);
    Q_INVOKABLE QString getNextFile();
    Q_INVOKABLE QString getPreviousFile();
    QString fileURL = "";
    QString currentDirectory = "";
    QString currentFileName = "";
    QStringList filesInDirectory;
    int pointerCurrentFile;
    bool isFileExist(const string& temp);
    QStringList getAllFiles(QDir fileDirectory);
signals:

};

#endif // BACKEND_H
