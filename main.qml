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
    title: qsTr("Hello World")

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

    Column {
        width: parent.width
        height: parent.height

        Item {
            width: parent.width
            height: parent.height-100
            MediaPlayer {
                id: mediaplayer
                source: "file:///E:/Pain.And.Glory.2019.1080p.BluRay.YTS.MrMovie.mp4"
//                seekable: true
            }

            VideoOutput {
                anchors.fill: parent
                source: mediaplayer
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                onPressed: mediaplayer.play();
            }
        }
        RowLayout {
            width: parent.width
            Text {
                id: durationPass
                color: "white"
                text: qsTr("00:00:00")
            }
            Slider {
                width: parent.width-100
                from: 1
                value: 1
                to: 100
            }
            Text {
                id: durationRemai
                color: "white"
                text: qsTr(root.msToTime(mediaplayer.duration))
            }
        }


        RowLayout {
            width: parent.width
            Button {
                   Layout.alignment: Qt.AlignHCenter
                   text: qsTr("Choose File")
                   highlighted: true
                   Material.background: Material.Blue
                   onClicked: {fileDialog.open();}
            }

            Button {
                id: playBtn
                   Layout.alignment: Qt.AlignHCenter
                   text: qsTr("Play")
                   highlighted: true
                   Material.background: Material.Blue

                   property bool status: false
                   onClicked: {
                       console.log(mediaplayer.duration);
                       if(status) {
                         status = false  ;
                         playBtn.text = "Pause";
                           mediaplayer.pause();
                       } else {
                           status = true;
                           playBtn.text = "Play"
                           mediaplayer.play();
                       }

                   }
            }
            Button {
                id: forwardBtn
                   Layout.alignment: Qt.AlignHCenter
                   text: qsTr("forward")
                   highlighted: true
                   Material.background: Material.Blue
                   onClicked: {
                       mediaplayer.seek(mediaplayer.position+10000);
                   }
            }
            Button {
                id: backwardBtn
                   Layout.alignment: Qt.AlignHCenter
                   text: qsTr("backward")
                   highlighted: true
                   Material.background: Material.Blue
                   onClicked: {
                       mediaplayer.seek(mediaplayer.position-10000);
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
               fileDialog.close();
    //           Qt.quit()
           }
           onRejected: {
               console.log("Canceled")
               fileDialog.close();
    //           Qt.quit()
           }
    //       Component.onCompleted: visible = true
       }
  }
   Timer {
      id: refreshTimer
      interval: 1000//30 // 60 Hz
      running: true
      repeat: true
      onTriggered: {
         durationPass.text =  root.msToTime(mediaplayer.position)
      }
   }
}


//Window {
//    visible: true
//    width: 900
//    height: 700
//    title: qsTr("Hello World")

//   Column {
//       width: parent.width
//       height: parent.width

//       Item {
//           width: parent.width
//           height: 600
//           MediaPlayer {
//               id: mediaplayer
//               source: "file:///E:/Pain.And.Glory.2019.1080p.BluRay.YTS.MrMovie.mp4"
//           }

//           VideoOutput {
//               anchors.fill: parent
//               source: mediaplayer
//           }

//           MouseArea {
//               id: playArea
//               anchors.fill: parent
//               onPressed: mediaplayer.play();
//           }
//       }

//    Video {
//        id: video
//        width : 800
//        height : 600
//        source: "file:///E:/Pain.And.Glory.2019.1080p.BluRay.YTS.MrMovie.mp4"

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                console.log("mouse clicked");
//                video.play()
//            }
//        }

//        focus: true
//        Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
//        Keys.onLeftPressed: video.seek(video.position - 5000)
//        Keys.onRightPressed: video.seek(video.position + 5000)
//    }

//    Button {
//           Layout.alignment: Qt.AlignHCenter
//           text: qsTr("Choose File")
//           highlighted: true
//           Material.background: Material.Blue
//           onClicked: {fileDialog.open();}
////           enabled: root.auth
//    }

//   }

//   FileDialog {
//       id: fileDialog
//       title: "Please choose a file"
//       folder: shortcuts.home
//       onAccepted: {
//           console.log("You chose: " + fileDialog.fileUrls)
//           fileDialog.close();
////           Qt.quit()
//       }
//       onRejected: {
//           console.log("Canceled")
//           fileDialog.close();
////           Qt.quit()
//       }
////       Component.onCompleted: visible = true
//   }
//}