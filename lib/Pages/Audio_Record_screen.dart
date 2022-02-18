import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_to_text/Pages/login_page.dart';
import 'package:voice_to_text/Pages/show_audio_history.dart';
import 'package:voice_to_text/Services/firebase_auth_service.dart';
import 'package:voice_to_text/Widget/progress_indicator.dart';

class AudioRecoedScreen extends StatefulWidget {
  const AudioRecoedScreen();

  @override
  _AudioRecoedScreenState createState() => _AudioRecoedScreenState();
}

class _AudioRecoedScreenState extends State<AudioRecoedScreen> with WidgetsBindingObserver {
  bool _allowWriteFile = false;
  bool _isRecording = false;
  var hasPermission = false;
  var showRecorder = false;
  bool _isPaused = false;
  bool showPlayer = false;
  bool isPlaying = false;
  String email = "";
  String trascriptedDat = "";
  bool isLoading = false;
  bool isDeNoise = false;
  bool isWordAnaylyaser = false;
  bool audioFinished = false;
  AudioPlayerState? audioPlayerState;

  String recordedFilePath = '';
  int dummyFilePathCount = 0;
  int _recordDuration = 0;


  var recorder = Record();
  Timer? _timer;
  Timer? _ampTimer;
  Amplitude? _amplitude;
  AudioPlayer player = AudioPlayer();
  Duration playerPosition = const Duration();
  Timer? _timer2;
  double? audioDuration;


  Future<void> startRecording() async {
    if (!_allowWriteFile) {
      // requestWritePermission();
    }
    print('working');
    // Start recording
    tempFile(".wav").then((path) async {
      if (await recorder.hasPermission()) {
        setState(() {
          showRecorder = true;
        });
        await recorder.start(
            // path: path, // required
            // encoder: AudioEncoder.AAC, // by default
            // bitRate: 128000,
            // samplingRate: 44100, // by default // by default
            );

        bool isRecording = await recorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      } else {
        Fluttertoast.showToast(msg: 'Accept Permission first');
      }
    });
  }

  Future<String> tempFile(String suffix) async {
    suffix = '.wav';

    if (!suffix.startsWith('.')) {
      suffix = '.$suffix';
    }
    var uuid = const Uuid();
    String path;
    if (!kIsWeb) {
      var tmpDir = await getApplicationDocumentsDirectory();
      path =
          '${join(tmpDir.path + '/' + 'AUD_${DateTime.now().millisecondsSinceEpoch}', uuid.v4())}$suffix';
      var parent = dirname(path);
      Directory(parent).createSync(recursive: true);
    } else {
      path = 'uuid.v4()}$suffix';
    }

    return path;
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = await new Directory(appDocDirectory.path +
            '/' +
            'AUD_${DateTime.now().millisecondsSinceEpoch}.wav')
        .create(recursive: true);

    return directory.path;
  }

  // requestWritePermission() async {
  //   if (await Permission.storage.request().isGranted) {
  //     setState(() {
  //       _allowWriteFile = true;
  //     });
  //   } else {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.storage,
  //     ].request();
  //   }
  // }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if(mounted) {
        setState(() => _recordDuration++);
      }
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await recorder.getAmplitude();
      if(mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    recordedFilePath = (await recorder.stop().whenComplete(() {
      setState(() {
        // audioDuration = player.duration.inSeconds.toDouble();
        audioDuration = double.parse("$_recordDuration");
        _isRecording = false;
      });
    }))!;
    print('PPP: ${recordedFilePath}');
    // widget.onStop(path);



  }

  Future<void> _pause() async {
    _timer!.cancel();
    _ampTimer!.cancel();
    await recorder.pause();
    setState(() {
      audioDuration = player.duration.inSeconds.toDouble();
      _isPaused = true;
    });


  }

  Future<void> _resume() async {
    _startTimer();
    await recorder.resume();

    setState(() => _isPaused = false);
  }

  List<String> audiolist = [];
  List<String> responseList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    getSharedPref();
    _isRecording = false;
    recorder.hasPermission().then((value) {
      hasPermission = value;
    });
    player.onPlayerStateChanged.listen((playerState) {
      if (playerState == AudioPlayerState.COMPLETED) {
        // Some Stuff
        print("jdhsaiudfhdsjfhdsjfvhdjvhfkdj");
        isPlaying = false;
        playerPosition = Duration.zero;
        setState(() {});
      }
    });

    player.onAudioPositionChanged.listen((position) {
      setState(() {
        playerPosition = position;

        // if (position.inSeconds >= player.duration.inSeconds) {
        //   playerPosition = Duration();
        //   isPlaying = false;
        // }
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
    recorder.stop();
    _isRecording = false;
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //stop your audio player
      player.stop();
    }else{
      print(state.toString());
    }
  }

  void audioFInished() {
    isPlaying = true;
    setState(() {});
  }

  void refress() {
    setState(() {
      player.stop();

    });
    _allowWriteFile = false;
    _isRecording = false;
    hasPermission = false;
    showRecorder = false;
    _isPaused = false;
    showPlayer = false;
    isPlaying = false;
    isLoading = false;
    // isDeNoise = false;
    // isWordAnaylyaser = false;
    audioFinished = true;
    audioDuration=0.0;
    recordedFilePath = '';
    dummyFilePathCount=0;
    startRecording();
    setState(() {});
  }

  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    isDeNoise = prefs.getBool("isDeNoise")??false;
    isWordAnaylyaser = prefs.getBool("isWordAnaylyaser")??false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(isPlaying){
          stopAudio();
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Exit"),
                content: const Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("YES"),
                    onPressed: () async {
                      SystemNavigator.pop();

                    },
                  ),
                  FlatButton(
                    child: const Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return Future.value(true);
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(email.toString(),style: const TextStyle(color: Colors.white,fontSize: 24),),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Show History',style: TextStyle(color: Colors.blue),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShowAudioHistory())
                    ).then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => const AudioRecoedScreen()),
                            (route) => false));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out',style: TextStyle(color: Colors.blue),),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await AuthClass().signOut();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('email');
                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => LogInPage()),
                            (route) => false);

                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text("Record Audio"),
          ),
          body: Stack(
            children: [
              recordedFilePath.isNotEmpty
                  ? Stack(
                children: [
                  recordedFilePath.isNotEmpty
                      ? InkWell(
                    onTap: () {
                      /// Need this to avoid click penetration
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width:
                            MediaQuery.of(context).size.width * 0.9,
                            height:
                            MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          refress();
                                        },
                                        child: const Icon(
                                          Icons.mic,
                                          size: 30,
                                        )),
                                    const SizedBox(width: 10),
                                    _buildPauseResumeControl(recordedFilePath),
                                    /*   isPlaying
                                                    ? _buildRecordStopControl(context)
                                                    : Container(),*/
                                                Slider(
                                                    value: playerPosition
                                                        .inMilliseconds
                                                        .toDouble(),
                                                    onChanged: (double value) {
                                                      player.seek((value / 1000)
                                                          .roundToDouble());
                                                    },
                                                    min: 0.0,
                                                    max: player
                                                        .duration.inMilliseconds
                                                        .toDouble()),
                                                Text(
                                                    '$audioDuration'),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                            //const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 100,),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Center(
                                        child: Text(trascriptedDat),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : Center(
                      child: showRecorder
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: showRecorder
                                      ? InkWell(
                                          onTap: () {
                                            /// Need this to avoid click penetration
                                          },
                                          child: Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(width: 20),
                                                      _buildPauseResumeControlA(),
                                                      const SizedBox(width: 20),
                                                      _buildRecordStopControl(
                                                          context),
                                                      const SizedBox(width: 20),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  _buildText(),
                                                  const SizedBox(height: 20),
                                                  !_isRecording && !_isPaused
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_isRecording) {
                                                                _stop();
                                                              }
                                                              showRecorder =
                                                                  false;
                                                            });
                                                          },
                                                          child: const Text('Done'),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                            )
                          : Center(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              startRecording();
                                            },
                                            child: const Icon(
                                              Icons.mic,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 120.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isDeNoise,
                                            onChanged: (value1) async{
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setBool('isDeNoise', value1!);
                                              setState(() {
                                                isDeNoise = value1;
                                              });
                                            },
                                          ),
                                          const Text("Denoise")
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 120.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isWordAnaylyaser,
                                            onChanged: (value2) async{
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setBool('isWordAnaylyaser', value2!);
                                              setState(() {
                                                isWordAnaylyaser = value2;
                                              });
                                            },
                                          ),
                                          const Text("Word Analyser")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
              Visibility(
                  visible: isLoading,
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.9),
                      child: const
                         CircilarprogressIndicator(),
                      )),
            ],
          ),
          bottomNavigationBar: recordedFilePath!=null && recordedFilePath!=""?InkWell(
            onTap: () {
              if (recordedFilePath != "") {
                if(dummyFilePathCount==0){
                  UpdateAudioAPI(context);

                }else{
                  Fluttertoast.showToast(msg: "please record Another audio");
                }
              } else {
                Fluttertoast.showToast(msg: "please record audio");
              }
              // UpdateAPIwithaudio();
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'CONVERT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ):Container(height:50,)),
    );
  }

  Widget _buildRecordStopControl(BuildContext context) {
    Icon icon;
    Color color;

    if (_isRecording || _isPaused) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.assignment_turned_in_rounded,
          color: Colors.green, size: 30);
      color = Colors.green.withOpacity(0.2);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : startRecording();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl(String url) {
   /* if (isPlaying && !_isPaused) {
      return const SizedBox.shrink();
    }*/

    Icon icon;
    Color color;

    if (isPlaying) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      // final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 50, height: 56, child: icon),
          onTap: () {
            isPlaying ? stopAudio() : playAudio(url);
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return const Text("Voice message recorded");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.white),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  playAudio(String url) {
    player.play(url).then((value) {
      setState(() {
        isPlaying = true;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isPlaying = false;
        playerPosition = const Duration();
      });
    });
  }

  stopAudio() {
    player.pause().then((value) {
      setState(() {

        isPlaying = false;
        playerPosition =playerPosition;
      });
    });
  }

  Widget _buildPauseResumeControlA() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    Icon icon;
    Color? color;

    if (!_isPaused) {
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
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Future<void> UpdateAudioAPI(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    //this raw material file
    File file =  File(recordedFilePath);

    var dataOffset = 74; // parse the WAV header or determine from a hex dump
    Uint8List assetByteData = await File(recordedFilePath).readAsBytes();
    File fileWav = await File(recordedFilePath).writeAsBytes(assetByteData);

    // this is byte array
    var bytes = Uint8List.fromList(assetByteData);

    // this is for int16Array
    var shorts = assetByteData.buffer.asInt16List(dataOffset);

    var key = "http://103.16.69.189:81/process";
    final uri = Uri.parse(key);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'audio': bytes,
      'denoise': isDeNoise,
      'word_analyze': isWordAnaylyaser,
      'user': email,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
try {
  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  ).timeout(const Duration(seconds: 10));

  int statusCode = response.statusCode;
  String responseBody = response.body;
  var res = jsonDecode(responseBody);


  if (statusCode == 200) {
    print(responseBody);
    setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(msg: "Converted Succesfully");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("AudioPath") != null &&
        prefs.getStringList("transcription") != null) {
      audiolist = (await prefs.getStringList("AudioPath"))!;
      responseList = (await prefs.getStringList("transcription"))!;
      audiolist.add(recordedFilePath);
      responseList.add(res["transcription"]);
      prefs.setStringList("AudioPath", audiolist);
      prefs.setStringList('transcription', responseList);
      setState(() {
        trascriptedDat = res["transcription"];
        dummyFilePathCount = 1;
      });
      /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowAudioHistory()),
        );*/
    } else {
      audiolist.add(recordedFilePath);
      responseList.add(res["transcription"]);
      prefs.setStringList("AudioPath", audiolist);
      prefs.setStringList('transcription', responseList);
      dummyFilePathCount = 1;
      setState(() {
        trascriptedDat = res["transcription"];
        dummyFilePathCount = 1;
      });
      /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowAudioHistory()),
        );*/
    }
  }
} catch (e) {
  throw TimeoutException('The connection has timed out, Please try again!');
}


  }
timeOut(BuildContext context){

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AudioRecoedScreen()));
    Fluttertoast.showToast(msg: "Something Went Wrong Please try after some time");

  }
}


