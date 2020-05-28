import 'dart:async';

import 'package:flutter/material.dart';
import 'musique.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cerv Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cerv Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Musique> maListDeMusique = [
    Musique('RAP galsen', 'Cerv', 'assets/cerv1.JPG', 'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    Musique('Hip Hop', 'Cerv', 'assets/cerv1.JPG', 'https://codabee.com/wp-content/uploads/2018/06/deux.mp3'),
  ];

  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription stateSubscription; 
  Musique maMusiqueActuelle;
  Duration position = Duration(seconds: 0);
  Duration duree = Duration(seconds: 10);
  PlayerState statut = PlayerState.stopped;
  
  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListDeMusique[0];
    configurationAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[ 
            Card(
              elevation: 9.0,
              child: Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset(maMusiqueActuelle.imagePath),
              ),
            ),
            texteAvecStyle(maMusiqueActuelle.titre, 1.5),
            texteAvecStyle(maMusiqueActuelle.artiste, 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                bouton(Icons.play_arrow, 45.0, ActionMusic.play),
                bouton(Icons.fast_forward, 30.0, ActionMusic.forward)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                texteAvecStyle('0:0', 0.8),
                texteAvecStyle('0:22', 0.8)
              ]
            ),
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: 30.0,
              inactiveColor: Colors.white,
              activeColor: Colors.red,
              onChanged: (double d) {
                setState(() {
                  Duration nouvelleDuration = Duration(seconds: d.toInt());
                  position = nouvelleDuration;
                });
              },
            )
          ],
        ),
      ), 
    );
  }

  IconButton bouton(IconData icone, double taille, ActionMusic action) {
    return IconButton(
      iconSize: taille,
      color: Colors.white,
      icon: Icon(icone),
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            print('Play');
            break;
          case ActionMusic.pause:
            print('Pause');
            break;
          case ActionMusic.forward:
            print('Forward');
            break;
          case ActionMusic.rewind:
            print('Rewind');
            break;
        }
      },
    );
  }

  Text texteAvecStyle(String data, double scale) {
    return Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      )
    );
  }
  void configurationAudioPlayer() {
    audioPlayer = AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen(
      (pos) => setState(() => position = pos)
    );
    stateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          //duree = audioPlayer.duration;
        });
      }else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    },
    onError: (message) {
      print('error: $message');
      setState(() {
        statut = PlayerState.stopped;
        duree = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    }
    );
  }
  Future play() async {
    await audioPlayer.play(maMusiqueActuelle.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }
  
}
enum ActionMusic {
    play,
    pause,
    rewind,
    forward
}
enum PlayerState {
  playing,
  stopped,
  paused
}