import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:find_track_app/auth/bloc/auth_bloc.dart';
import 'package:find_track_app/favorites_page.dart';
import 'package:find_track_app/providers/songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic songsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                    style: TextStyle(fontSize: 18),
                    context.watch<Songs_Provider>().isRecording
                        ? "Escuchando..."
                        : "Toque para escuchar"),
              ),
            ),
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                //songsList = context.watch<Songs_Provider>().getSongList;
                context.read<Songs_Provider>().setRecording();
                searchingTrack();
                Timer(const Duration(seconds: 10), () async {
                  context.read<Songs_Provider>().setRecording();
                });
              },
              child: AvatarGlow(
                animate: context.watch<Songs_Provider>().isRecording,
                glowColor: Colors.red,
                endRadius: 130.0,
                child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    backgroundImage: AssetImage(('assets/music_icon.png'))),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    tooltip: "Ver Favoritos",
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navegar a otra pantalla
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Favorites(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width:20),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    tooltip: "Cerrar Sesión",
                    icon: Icon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Sign Out
                      print("signing out");
                        BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                      context.read<Songs_Provider>().inputData();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> searchingTrack() async {
     Record record = Record();
    Directory? appDocDir = await getExternalStorageDirectory();
    //String? appPath = appDocDir?.path;

    print(appDocDir!.path);
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '${appDocDir.path}/newTrack.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }

// Get the state of the recorder
    bool isRecording = await record.isRecording();
    if (isRecording) {
      Timer(const Duration(seconds: 6), () async {
        String? songPath = await record.stop();
        print(songPath);
      
    File song = File(songPath!);
        Uint8List fileBytes = await song.readAsBytesSync();
        String songString = base64Encode(fileBytes);
    
    dynamic detectedSong = await context.read<Songs_Provider>().searchSong(songString);
    print(detectedSong);
    print(detectedSong["result"]);
   
    if (detectedSong["result"] != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Details(
            selectedSong: detectedSong["result"],
            //songsList: songsList
          ),
        ),
      );
    } else {
      final snackBar = SnackBar(
        content: const Text('No encontramos la canción!'),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
            // Some code to undo the change.
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      }
      );
  }
  }
}
