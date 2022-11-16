import 'dart:ui';
import 'package:find_track_app/providers/songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemSong extends StatelessWidget {
  final dynamic track;

  ItemSong({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 350,
      padding: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: (){
                   showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              title: const Text('Redirigir a sitio web'),
                              content: const Text(
                                  'Será redirigido a opciones para abrir la canción ¿Quieres continuar?'),
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
                                     _launchUrl(track["song_link"]);
                                    Navigator.pop(context, 'OK');
                                    //print(context.watch<Songs_Provider>().getSongList);
                                  },
                                  child: const Text('Continuar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              250, 140, 130, 190))),
                                ),
                              ]));
                },
                child: Image.network(
                    '${track["spotify"]["album"]["images"][0]["url"]}',
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              // posicionar en ciertas coordenadas
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.all(4),
                  color: Color.fromARGB(243, 60, 95, 190),
                  child: Column(
                    children: [
                      Text(
                        '${track["title"]}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        '${track["artist"]}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: IconButton(
                enableFeedback: false,
                tooltip: "Eliminar de favoritos",
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
                color: Colors.white,
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              title: const Text('Eliminar de Favoritos'),
                              content: const Text(
                                  'El elemento será eliminado de tus Favoritos ¿Quieres continuar?'),
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
                                        .deleteFavorite(track);
                                        //TODO: Necesito eliminar de Firebase
                                        
                                    Navigator.pop(context, 'OK');
                                    //print(context.watch<Songs_Provider>().getSongList);
                                  },
                                  child: const Text('Continuar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              250, 140, 130, 190))),
                                ),
                              ]));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
  
}
