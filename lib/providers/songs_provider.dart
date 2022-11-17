import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:find_track_app/http_request.dart';

class Songs_Provider extends ChangeNotifier {
  bool _isRecording = false;
  List<dynamic> get getSongList => _songsList;

  List<dynamic> _songsList = [];
  bool get isRecording => _isRecording;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void initFavoritesList() async{
    print("Loading Favorites");

     String uid = inputData();

    final QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user_tracks')
        .doc(uid)
        .collection('favorites')
        .get();

    print("reading from database");

    if(_songsList.isEmpty){
      for (var i = 0; i < res.docs.length; i++) {
      _songsList.add(res.docs[i].data());
      print(_songsList[i]);
     }
    }
    print("Songs List ${_songsList}");
  }
  
  String inputData() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    print(uid);

    return uid;
  }
  
  void setRecording() {
    _isRecording = !_isRecording;
    notifyListeners();
  }

  Future<dynamic> searchSong(songString) async {
    print("Making POST");

    var response = await HttpRequest().postToAPI(songString);

    print(response);

    print("Obtaining Response");

    if (response.statusCode == 200) {
      //print(response.body);
      var res = jsonDecode(response.body);
      //dynamic obj = res["result"];
      notifyListeners();
      return res;
    }
  }

  void addFavorite(dynamic song) async {
    String uid = inputData();

    final QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user_tracks')
        .doc(uid)
        .collection('favorites')
        .get();

    print("reading from database");

    bool inFavorites = false;

    for (var i = 0; i < _songsList.length; i++) {
      if (song["title"] == res.docs[i]["title"]) {
        print("Song already in Favorites");
        inFavorites = true;
        break;
      }
    }

    print("In favorites: ${inFavorites}");

    if (!inFavorites) {
      db.collection("user_tracks").doc(uid).collection("favorites").add({
        "image": song["spotify"]["album"]["images"][0]["url"],
        "link": song["song_link"],
        "title": song["title"],
        "artist": song["artist"],
        "album": song["album"],
        "release_date": song["release_date"],
        "spotify": song["spotify"]["external_urls"]["spotify"],
        "song_link": song["song_link"],
        "apple_music": song["apple_music"]["url"]
      });
      print("Added to Favorites");

      final QuerySnapshot res2 = await FirebaseFirestore.instance
        .collection('user_tracks')
        .doc(uid)
        .collection('favorites')
        .get();

      _songsList.add(res2.docs.last.data());

      print(_songsList);
    }

    notifyListeners();
  }

  void deleteFavorite(dynamic song) async {
    String uid = inputData();

    final QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user_tracks')
        .doc(uid)
        .collection('favorites')
        .get();

    print("reading from database");

    bool inFavorites = false;
    String song_uid = "";

    for (var i = 0; i < _songsList.length; i++) {
      if (song["title"] == res.docs[i]["title"]) {
        print("Song already in Favorites");
        song_uid = res.docs[i].id;
        print("Song uid: ${song_uid}");
        inFavorites = true;
        break;
      }
    }

    print("In favorites: ${inFavorites}");

    if (inFavorites) {
      _songsList.remove(song);

      print("reading from database");

      await FirebaseFirestore.instance
          .collection('user_tracks')
          .doc(uid)
          .collection('favorites')
          .doc(song_uid)
          .delete();

      print("Deleted from Favorites");
    }

    notifyListeners();
  }
}
