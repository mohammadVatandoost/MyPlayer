#include "backend.h"

BackEnd::BackEnd(QObject *parent) : QObject(parent)
{
     readSubtitleFile("./en.srt");
}

void BackEnd::readSubtitleFile(QString directory)
{
      cout<< "readSubtitleFile:"<< directory.toStdString()<<endl;
      if(!isFileExist(directory.toStdString())) {
          cout<< "file does not exist"<<endl;
          return ;
      }
      SubtitleParserFactory *subParserFactory = new SubtitleParserFactory(directory.toStdString());
      SubtitleParser *parser = subParserFactory->getParser();

      sub = parser->getSubtitles();

      ofstream myfile;
      myfile.open ("out.srt");
      cout<< "sub.size()"<< sub.size()<<endl;

}

QString BackEnd::getSubtitleText(double playTime)
{
    for(SubtitleItem * element : sub) {
        double startTime = element->getStartTime();
        double endTime = element->getEndTime();
        if( (startTime <= playTime) && (playTime <= endTime)) {
            return QString::fromStdString(element->getText());
        }
    }
    return "";
}

void BackEnd::chooseFile(QString directory)
{
    cout<< "chooseFile: "<< directory.toStdString()<<endl;
    directory.replace("file:///", "");
    cout<< "chooseFile after pre: "<< directory.toStdString()<<endl;
    fileURL = directory;
    QFileInfo file(directory);
    if(!file.exists()) {
        cout<< "file does not exist"<<endl;
    } else {
       currentFileName = file.fileName();
       currentDirectory = directory.replace(currentFileName, "");
       cout<< "currentDirectory: "<< currentDirectory.toStdString()<<endl;
       filesInDirectory = getAllFiles(file.dir());
    }

}

QString BackEnd::getNextFile()
{
    if(filesInDirectory.size() ==0) {return  "";}
    if( (pointerCurrentFile+1) < filesInDirectory.size()) {
        pointerCurrentFile = pointerCurrentFile + 1;
        return "file:///"+currentDirectory+filesInDirectory[pointerCurrentFile];
    }
    pointerCurrentFile = 0 ;
    return "file:///"+currentDirectory+filesInDirectory[pointerCurrentFile];
}

QString BackEnd::getPreviousFile()
{
    if(filesInDirectory.size() ==0) {return  "";}
    if( (pointerCurrentFile-1) >=  0) {
        pointerCurrentFile = pointerCurrentFile - 1;
        return "file:///"+currentDirectory+filesInDirectory[pointerCurrentFile];
    }
    pointerCurrentFile = filesInDirectory.size() - 1 ;
    return "file:///"+currentDirectory+filesInDirectory[pointerCurrentFile];
}

bool BackEnd::isFileExist(const string &temp)
{
    if (FILE *file = fopen(temp.c_str(), "r")) {
            fclose(file);
            return true;
        } else {
            return false;
    }
}

QStringList BackEnd::getAllFiles(QDir fileDirectory)
{
   QStringList fileList = fileDirectory.entryList(QStringList()<< "*.mp4" << "*.mp3" << "*.mkv", QDir::Files);
   for(int i=0; i< fileList.size(); i++) {
       if(fileList[i] == currentFileName ) {
           pointerCurrentFile = i;
       }
//      cout<< fileList[i].toStdString()<<endl;
   }
   return fileList;
}
