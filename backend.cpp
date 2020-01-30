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
//      for(SubtitleItem * element : sub)
//      {
//          cout<<"BEGIN"<<endl;
////          cout<<"startString : "<<element->getStartTimeString()<<endl;
//          cout<<"start : "<<element->getStartTime()<<endl;
////          cout<<"endString : "<<element->getEndTimeString()<<endl;
//          cout<<"end : "<<element->getEndTime()<<endl;
//          cout<<"text : "<<element->getText()<<endl;
//          cout<<"justDialogue : "<<element->getDialogue()<<endl;
////          cout<<"words count : "<<element->getWordCount()<<endl;
////          cout<<"words :";
////          std::vector<std::string> word = element->getIndividualWords();
////              for(std::string display : word)
////                  cout<<display<<", ";
////              cout<<endl;

////          cout<<"speakerCount : "<<element->getSpeakerCount()<<endl;
////          cout<<"speakers : ";
////          if(element->getSpeakerCount())
////          {
////              std::vector<std::string> name = element->getSpeakerNames();
////              for(std::string display : name)
////                  cout<<display<<", ";
////              cout<<endl;
////          }

////          cout<<"ignore : "<<element->getIgnoreStatus()<<endl;
//          cout<<"END"<<endl<<endl;
//      }
}

QString BackEnd::getSubtitleText(double playTime)
{
    for(SubtitleItem * element : sub) {
        double startTime = element->getStartTime();
        double endTime = element->getEndTime();
        if( (startTime <= playTime) && (playTime <= endTime)) {
//            cout<< "getSubtitleText: founded"<< element->getText()<<endl;
            return QString::fromStdString(element->getText());
        }
    }
//    cout<< "getSubtitleText: not founded"<< endl;
    return "";
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
