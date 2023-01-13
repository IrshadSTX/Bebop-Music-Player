import 'package:bebop_music/screens/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetTopBeatsController {
  static ValueNotifier<List<SongModel>> topBeatsNotifier = ValueNotifier([]);
  static List<dynamic> topBeats = [];
  static List<SongModel> topBeatSong = [];

  static Future<void> addTopBeats(item) async {
    final topBeatsDb = await Hive.openBox('topBeatsNotifier');
    await topBeatsDb.add(item);
    getTopBeatSongs();
    topBeatsNotifier.notifyListeners();
  }

  static Future<void> getTopBeatSongs() async {
    final topBeatsDb = await Hive.openBox('topBeatsNotifier');
    topBeats = topBeatsDb.values.toList();
    displayTopBeats();
    topBeatsNotifier.notifyListeners();
  }

  static Future<List> displayTopBeats() async {
    final topBeatsDb = await Hive.openBox('topBeatsNotifier');
    final topBeatsSongItems = topBeatsDb.values.toList();
    topBeatsNotifier.value.clear();
    topBeats.clear();
    for (var i = 0; i < topBeatsSongItems.length; i++) {
      for (var j = 0; j < startSong.length; j++) {
        if (topBeatsSongItems[i] == startSong[j].id) {
          topBeatsNotifier.value.add(startSong[j]);
          topBeats.add(startSong[j]);
        }
      }
    }
    return topBeats;
  }
}
