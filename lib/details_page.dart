import 'package:find_track_app/providers/songs_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/*void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Details(),
    );
  }
}*/

class Details extends StatelessWidget {
  final dynamic selectedSong;
  //final dynamic songsList;

  const Details({
    Key? key,
    required this.selectedSong,
    //required this.songsList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Here you go'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("********************************");
                  //context.read<Songs_Provider>().addFavorite({selectedSong["artist"], selectedSong["title"]});
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              title: const Text('Agregar a Favoritos'),
                              content: const Text(
                                  'El elemento será agregado a tus Favoritos ¿Quieres continuar?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancelar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              250, 140, 130, 190))),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<Songs_Provider>()
                                        .addFavorite(selectedSong);
                                        //TODO:Necesito mandar a Firebase aquí la canción

                                    Navigator.pop(context, 'OK');
                                    
                                    //print(context.watch<Songs_Provider>().getSongList);
                                  },
                                  child: const Text('Continuar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              250, 140, 130, 190))),
                                ),
                              ]));
                })
          ],
        ),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                    //'https://akamai.sscdn.co/uploadfile/letras/albuns/1/6/a/6/608811511359601.jpg',
                    // width: 300,
                    "${selectedSong["spotify"]["album"]["images"][0]["url"]}",
                    height: 390,
                    fit: BoxFit.fill),
                SizedBox(height: 40),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        //"Infinity",
                        "${selectedSong["title"]}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600)),
                    Text(
                        //"Feel Something",
                        "${selectedSong["album"]}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Text(
                        //"James Young",
                        "${selectedSong["artist"]}",
                        style: TextStyle(fontWeight: FontWeight.w200)),
                    Text(
                        //"2017-06-23",
                        "${selectedSong["release_date"]}",
                        style: TextStyle(fontWeight: FontWeight.w200))
                  ],
                ),
                SizedBox(height: 45),
                Column(
                  children: [
                    Text("Abrir con:",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w200)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            child: IconButton(
                              padding: EdgeInsets.only(bottom: 20),
                              tooltip: "Ver en Spotify",
                              icon: Icon(Icons.contactless,
                                  color: Colors.white, size: 50),
                              onPressed: () {
                                print(selectedSong["spotify"]["external_urls"]
                                    ["spotify"]);
                                _launchUrl(selectedSong["spotify"]
                                    ["external_urls"]["spotify"]);
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(bottom: 20),
                          tooltip: "Ver en Deezer",
                          icon: Icon(Icons.podcasts,
                              color: Colors.white, size: 50),
                          onPressed: () {
                            print(selectedSong["song_link"]);
                            _launchUrl(selectedSong["song_link"]);
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.only(bottom: 25),
                          tooltip: "Ver en Apple Music",
                          icon:
                              Icon(Icons.apple, color: Colors.white, size: 50),
                          onPressed: () {
                            print(selectedSong["apple_music"]["url"]);
                            _launchUrl(selectedSong["apple_music"]["url"]);
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
