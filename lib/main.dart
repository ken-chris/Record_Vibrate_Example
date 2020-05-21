import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

/// demonstrates the recording widget linked to a playback widget.
void main() {
  runApp(MyApp());
}

/// Example app.
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Initialize Variables
  FlutterSoundRecorder _flutterRecord = new FlutterSoundRecorder();
  String _recorderTxt = "Getting Save Location";

  //Vibrate Functions
  void _vibrate() {
    Vibration.vibrate(duration: 2000, amplitude: 255);
  }

  //Recording Functions
  Future<void> startRecorder() async  {
    Directory appDocDirectory = await getExternalStorageDirectory();
    //Directory appDocDirectory = await getApplicationDocumentsDirectory();
    if (await Permission.microphone.request().isGranted) {
    print(appDocDirectory.path);
    setState(() {
      _recorderTxt = appDocDirectory.path;
    });
    await _flutterRecord.openAudioSession(
      category: SessionCategory.record,
    );
    await _flutterRecord.startRecorder(
      codec: Codec.aacADTS,
      toFile: appDocDirectory.path + "/test3.mp4", // TODO implement text input file extension
    sampleRate: 16000 // TODO implement variable sample_rate
    );
    print(_flutterRecord.recorderState);
    _vibrate();
    }
    else { Permission.microphone.request(); }
  }

  void stopRecorder() async {
    print(_flutterRecord.recorderState);
    await _flutterRecord.closeAudioSession();
    print(_flutterRecord.recorderState);

  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Sound'),
          ),
          body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_recorderTxt',
                style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
            ),
          ),
              RaisedButton(
                onPressed: startRecorder,
                child: const Text('Record', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: stopRecorder,
                child: const Text('Stop', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: _vibrate,
                child: const Text('Vibrate', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
