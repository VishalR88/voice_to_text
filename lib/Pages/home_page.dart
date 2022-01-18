import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Model/listitems_model.dart';

import 'Audio_Record_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({ required this.email});
  String email;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioCache audioCache;
  late AudioPlayer audioPlayer;
  bool iisPlaying = false;
  bool oisplaying = false;

  List<ListItem> tList = [
    (ListItem(
      1,
      "Input",
      "test1",
      "https://luan.xyz/files/audio/ambient_c_motion.mp3",
      "Output",
      "test1",
      "https://luan.xyz/files/audio/nasa_on_a_mission.mp3",
      false,
    )),
    (ListItem(
      2,
      "Input",
      "test2",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test2",
      "https://luan.xyz/files/audio/ambient_c_motion.mp3",
      false,
    )),
    (ListItem(
      3,
      "Input",
      "test3",
      "https://luan.xyz/files/audio/nasa_on_a_mission.mp3",
      "Output",
      "test3",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      4,
      "Input",
      "test4",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test4",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      5,
      "Input",
      "test5",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test5",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      6,
      "Input",
      "test6",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test6",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      7,
      "Input",
      "test7",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test7",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      8,
      "Input",
      "test8",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test8",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      9,
      "Input",
      "test9",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test9",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
    (ListItem(
      10,
      "Input",
      "test10",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      "Output",
      "test10",
      "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      false,
    )),
  ];

  @override
  void initState() {
    super.initState();
   // audioPlayer = AudioPlayer();
   // audioCache = AudioCache(fixedPlayer: audioPlayer);
  }

  late bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
      ),
      body:Container(),
      /*ListView.builder(
        itemCount: tList.length,
        itemBuilder: (BuildContext context, int position) {
          ListItem item = tList[position];
          return ListItemCard(
            inputtitle: tList[position].inputtitle,
            inputname: tList[position].inputname,
            outputtitle: tList[position].outputtitle,
            outputname: tList[position].outputname,
            inputontap: () {
              audioPlayer!.play('${tList[position].inputaudioLink}');
            },
            ontapofinputicon: () {
              audioPlayer!.play('${tList[position].inputaudioLink}');
            },
            outputontap: () {
              audioPlayer!.play('${tList[position].outputaudioLink}');
            },
            ontapofoutputicon: () {
              audioPlayer!.play('${tList[position].outputaudioLink}');
              // audioPlayer!.stop();
            },
            // inputisplaying: iisPlaying,
            // outputisplaying: oisplaying,
          );
        },
      )*/
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AudioRecoedScreen()),
          );

         // audioPlayer!.stop();
         // SharedPreferences prefs = await SharedPreferences.getInstance();
         // prefs.remove('email');
         // ScaffoldMessenger.of(context).clearSnackBars();
          /*ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Prefrence Cleared")));*/
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // void ontapofoicon(oisplaying) {
  //   Future.delayed(Duration(microseconds: 100), () {
  //     setState(() {
  //       oisplaying != oisplaying;
  //     });
  //   });
  // }

  // void ontapofiicon(inputisPlaying) {
  //   Future.delayed(Duration(microseconds: 100), () {
  //     setState(() {
  //       inputisPlaying != inputisPlaying;
  //     });
  //   });
  // }
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
