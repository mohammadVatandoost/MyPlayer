import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQuick.Controls.Material 2.3
import QtMultimedia 5.12
import QtQuick.Dialogs 1.0

Window {
    visible: true
    width: 900
    height: 700
    title: qsTr("EasyPlayer")
    flags: Qt.FramelessWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.Window
Rectangle {
    id: root
    color: "black"
    width: parent.width
    height: parent.height
    function msToTime(duration) {
      var milliseconds = parseInt((duration % 1000) / 100),
        seconds = Math.floor((duration / 1000) % 60),
        minutes = Math.floor((duration / (1000 * 60)) % 60),
        hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

      hours = (hours < 10) ? "0" + hours : hours;
      minutes = (minutes < 10) ? "0" + minutes : minutes;
      seconds = (seconds < 10) ? "0" + seconds : seconds;

      return hours + ":" + minutes + ":" + seconds;
    }

    function playFile(temp) {
        mediaplayer.source = temp;
        sliderFilePosition.value = 1;
        mediaplayer.play();
    }

    Column {
        width: parent.width
        height: parent.height
        z: 1
        Item {
            width: parent.width
            height: parent.height
            MediaPlayer {
                id: mediaplayer
                source: "file:///E:/1.mp4"
            }

            VideoOutput {
                anchors.fill: parent
                source: mediaplayer
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                onPressed: {

                }
            }
        }

     }

    Text {
        id: subtitleText
        z: 10
        text: qsTr("")
        y: sliderContainer.y-50
        font.pixelSize: 18
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RowLayout {
            id: sliderContainer
            width: parent.width*0.95
            y: parent.height-100
            z: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: durationPass
                color: "white"
                text: qsTr("00:00:00")
            }
            Slider {
                id: sliderFilePosition
                implicitWidth: parent.width-150
                from: 1
                value: 1
                to: 1000
                onMoved: {
                    mediaplayer.seek(sliderFilePosition.value*mediaplayer.duration/1000);
                }
            }
            Text {
                id: durationRemai
                color: "white"
                text: qsTr(root.msToTime(mediaplayer.duration))
            }
        }


        RowLayout {
            width: parent.width
            y: parent.height-50
            z: 10
            Button {
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "choose file"
                   icon.source: "icons/upload.png"
                   highlighted: true
                   Material.background: "black"
                   onClicked: {fileDialog.open();}
            }

            Button {
                id: prviousBtn
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "skip-previous"
                   icon.source: "icons/skip-previous72.png"
                   highlighted: true
                   Material.background: "black"
                   onClicked: {
                       root.playFile(BackEnd.getPreviousFile());
                   }
            }

            Button {
                id: backwardBtn
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "skip-backward"
                   icon.source: "icons/skip-backward72.png"
                   highlighted: true
                   Material.background: "black"
                   onClicked: {
                       mediaplayer.seek(mediaplayer.position-10000);
                   }
            }

            Button {
                id: playBtn
                 property bool status: false
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "play"
                   icon.source: status ? "icons/pause96.png" : "icons/play96.png"
                   highlighted: true
                   Material.background: "black"

                   onClicked: {
                       console.log(mediaplayer.duration);
                       if(status) {
                         status = false  ;
                           mediaplayer.pause();
                       } else {
                           status = true;
                           mediaplayer.play();
                       }

                   }
            }

            Button {
                id: forwardBtn
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "skip-forward"
                   icon.source: "icons/skip-forward72.png"
                   highlighted: true
                   Material.background: "black"
                   onClicked: {
                       mediaplayer.seek(mediaplayer.position+10000);
                   }
            }

            Button {
                id: nextBtn
                   Layout.alignment: Qt.AlignHCenter
                   icon.name: "skip-next"
                   icon.source: "icons/skip-next72.png"
                   highlighted: true
                   Material.background: "black"
                   onClicked: {
                      root.playFile(BackEnd.getNextFile());
                   }
            }

            RowLayout {
                width: 200
                Button {
                    id: volumeBtn
                    width: 50
                    property int volumeStatus: 0
                       Layout.alignment: Qt.AlignHCenter
                       icon.name: "skip-next"
                       icon.source: ( volumeStatus == 0 ) ? "icons/volume-high.png" : "icons/volume-off.png"
                       highlighted: true
                       Material.background: "black"
                       onClicked: {
                          volumeStatus = volumeStatus+1;
                           if(volumeStatus == 2) {
                               volumeStatus = 0;
                               mediaplayer.volume =  sliderVolumePosition.previousValue/100;
                               sliderVolumePosition.value = sliderVolumePosition.previousValue;
                           } else {
                               sliderVolumePosition.previousValue = sliderVolumePosition.value;
                               sliderVolumePosition.value = 0;
                               mediaplayer.volume =  0;
                           }
                       }
                }

                Slider {
                    id: sliderVolumePosition
                    property int previousValue: 50
                    implicitWidth: 150
                    from: 0
                    value: 50
                    to: 100
                    onMoved: {
                        mediaplayer.volume =  sliderVolumePosition.value/100;
                    }
                }
            }
        }

       FileDialog {
           id: fileDialog
           title: "Please choose a file"
           folder: shortcuts.home
           onAccepted: {
               console.log("You chose: " + fileDialog.fileUrls)
               mediaplayer.source = fileDialog.fileUrls[0];
               sliderFilePosition.value = 1;
               mediaplayer.play();
//               var temp = ""+fileDialog.fileUrl;
//               var selectedURL = temp.slice(temp.lastIndexOf("/")+1, temp.length)
//               console.log(selectedURL)
                BackEnd.chooseFile(fileDialog.fileUrls[0]);

//               fileDialog.close();
    //           Qt.quit()
           }
           onRejected: {
               console.log("Canceled")
               fileDialog.close();
    //           Qt.quit()
           }
    //       Component.onCompleted: visible = true
       }

       Keys.onRightPressed: {
           mediaplayer.seek(mediaplayer.position+10000);
           durationPass.text =  root.msToTime(mediaplayer.position);
       }

       Keys.onLeftPressed: {
           mediaplayer.seek(mediaplayer.position-10000);
           durationPass.text =  root.msToTime(mediaplayer.position);
       }

       Keys.onUpPressed: {
           if(sliderVolumePosition.value < 100) {
               sliderVolumePosition.value = sliderVolumePosition.value + 1;
               mediaplayer.volume = sliderVolumePosition.value/100;
           }
       }

       Keys.onDownPressed: {
           if(sliderVolumePosition.value !== 0) {
               sliderVolumePosition.value = sliderVolumePosition.value - 1;
               mediaplayer.volume = sliderVolumePosition.value/100;
           }
       }
  }

   Timer {
      id: refreshTimer
      interval: 1000//30 // 60 Hz
      running: true
      repeat: true
      onTriggered: {
         durationPass.text =  root.msToTime(mediaplayer.position);
         subtitleText.text = BackEnd.getSubtitleText(mediaplayer.position) ;
          if(mediaplayer.duration == mediaplayer.position && mediaplayer.duration>0) {
//              console.log("******** it reach last ************")
              root.playFile(BackEnd.getNextFile());
          }
      }
   }


}
