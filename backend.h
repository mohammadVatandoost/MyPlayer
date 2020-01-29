#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <iostream>
#include "srtparser.h"
#include <fstream>

using namespace std;

class BackEnd : public QObject
{
    Q_OBJECT
public:
    explicit BackEnd(QObject *parent = nullptr);
//    SubtitleParserFactory *subParserFactory ;
//    SubtitleParser *parser;
    vector<SubtitleItem*> sub;
    Q_INVOKABLE void readSubtitleFile(QString directory);
    Q_INVOKABLE QString getSubtitleText(double playTime);
    bool isFileExist(const string& temp);
signals:

};

#endif // BACKEND_H
