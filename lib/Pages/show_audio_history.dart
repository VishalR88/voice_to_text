import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAudioHistory extends StatefulWidget {
  const ShowAudioHistory({Key? key}) : super(key: key);

  @override
  _ShowAudioHistoryState createState() => _ShowAudioHistoryState();
}

class _ShowAudioHistoryState extends State<ShowAudioHistory> {
  String recordedFilePath = "";
  String response = "";
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool showPlayer = true;
  Duration playerPosition = const Duration();
  List<String> audioList = [];
  List<String> responseList = [];
  var isPlayingList;
  var num=0;
  int lastPlayingIndex=-2;
  List<Duration> duratiolist = [];

  @override
  void initState() {
    getSharedPref();
    player.onAudioPositionChanged.listen((position) {
      setState(() {
        playerPosition = position;
        // if (position.inSeconds >= player.duration.inSeconds) {
        //   playerPosition = Duration();
        //   isPlaying = false;
        // }
      });
    });
    player.onPlayerStateChanged.listen((playerState) {
      if (playerState == AudioPlayerState.COMPLETED) {
        // Some Stuff
        print("jdhsaiudfhdsjfhdsjfvhdjvhfkdj");
        for (int i = 0; i < isPlayingList.length; i++) {
          isPlayingList[i]=false;
          setState(() {

          });
        }
      }
    });
    super.initState();
  }

  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    audioList = prefs.getStringList('AudioPath')!;
     audioList= audioList.reversed.toList();
    responseList = prefs.getStringList('transcription')!;
     responseList= responseList.reversed.toList();
    num=audioList.length;
    isPlayingList = List.filled(num, false, growable: false);
    for (int i = 0; i < isPlayingList.length; i++) {
      isPlayingList[i]=false;
      setState(() {
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Audio History"),
      ),
      body:audioList.isEmpty ? const Center(child: Text("No history found",style: TextStyle(color: Colors.black,fontSize: 20),)) : ListView.builder(
          itemCount: audioList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: audioList[index].isNotEmpty
                  ? InkWell(
                      onTap: () {
                        /// Need this to avoid click penetration
                      },
                      child: SizedBox(
                        width: 100,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    _buildPauseResumeControl(
                                        audioList[index], index),
                                    const SizedBox(width: 10),
                                    // isPlaying
                                    //     ? _buildRecordStopControl(
                                    //         selectedAudio)
                                    //     : Container(),
                                    /*Slider(
                                     value: playerPosition.inMilliseconds
                                         ?.toDouble() ??
                                         0.0,
                                     onChanged: (double value) {
                                       return player.seek((value / 1000)
                                           .roundToDouble());
                                     },
                                     min: 0.0,
                                     max: player.duration.inMilliseconds
                                         .toDouble()),
                                     Text(
                                   '${player.duration.inSeconds.toDouble()}'),*/
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                //const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              title: Text(responseList[index]),
            );
          }),
    );
  }

  Widget _buildPauseResumeControl(String url, int index) {
    // if (isPlaying && !isPaused) {
    //   return const SizedBox.shrink();
    // }

    Icon icon;
    Color? color;

    if (isPlayingList[index]) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      // final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      // color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 50, height: 56, child: icon),
          onTap: () {
            if(lastPlayingIndex==index){
              isPlayingList[index] ? stopAudio(index) : playAudio(url, index);
            }else if(lastPlayingIndex==-2){
              isPlayingList[index] ? stopAudio(index) : playAudio(url, index);
            }else{
             player.stop();
             isPlayingList[index] ? stopAudio(index) : playAudio(url, index);
            }

          },
        ),
      ),
    );
  }

  playAudio(String url, int index) {
    // stopAudio(index);
    // player.stop();

    player.play(url).then((value) {
      setState(() {
        lastPlayingIndex=index;
        for (int i = 0; i < isPlayingList.length; i++) {
          isPlayingList[i]=false;
          setState(() {

          });
        }
         isPlayingList[index] = true;
        setState(() {

        });
       // notifyListPlay(index);
      });
    }).onError((error, stackTrace) {
      setState(() {
        isPlayingList[index] = true;

        playerPosition = const Duration();
      });
    });
  }


  stopAudio(int index) {

    player.pause().then((value) {
      setState(() {
        for (int i = 0; i < isPlayingList.length; i++) {
          isPlayingList[i]=false;
          setState(() {

          });
        }
         isPlayingList[index] = false;
       // notifyListPause(index);
        playerPosition = const Duration();
      });
    });
  }
  void notifyListPlay(int index){

    for (int i = 0; i < isPlayingList.length; i++) {
      if(i!=index){
        setState(() {
          isPlayingList[index] = false;
        });
      }else{
        setState(() {
        });

      }
    }

  }

  void notifyListPause(int index){
    for (int i = 0; i < isPlayingList.length; i++) {
      if(i==index){
        setState(() {
          isPlayingList[index] = false;
        });
      }else{

      }
    }
  }
}
