import 'package:bebop_music/db/model/bebop_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class PlaylistDb {
  static ValueNotifier<List<BebopModel>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<BebopModel>('playlistDb');

  static Future<void> addPlaylist(BebopModel value) async {
    final playlistDb = Hive.box<BebopModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<BebopModel>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<BebopModel>('playlistDb');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> editList(int index, BebopModel value) async {
    final playlistDb = Hive.box<BebopModel>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }
}
