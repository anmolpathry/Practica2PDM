import 'package:find_track_app/providers/songs_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'item_track.dart';

/*void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Favorites(),
    );
  }
}*/

class Favorites extends StatelessWidget {

  Favorites({
    Key? key, 
  }) : super(key: key);


  final List<Map<String, String>> _listElements = [
    {
      "title": "Infinity",
      "artist": "James Young",
      "image": "https://akamai.sscdn.co/uploadfile/letras/albuns/1/6/a/6/608811511359601.jpg",
    },
    {
      "title": "Labios Rotos",
      "artist": "Zoé",
      "image": "https://i.scdn.co/image/ab67616d0000b273e245d1799a4525605b87de45",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: 
        Column(
          children: [
            _songsArea(context)
          ],
        ),
    );
  }

  Widget _songsArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 87,
      child: _songsList(context),
    );
  }

  Widget _songsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: context.watch<Songs_Provider>().getSongList.length,
      itemBuilder: (BuildContext context, int index) {
        var _itemSong = context.watch<Songs_Provider>().getSongList[index];
        return ItemSong(track: _itemSong);
      },
    );
  }
}
