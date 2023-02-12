import 'package:bebop_music/controller/get_all_song.dart';
import 'package:flutter/cupertino.dart';

class NowPlayingScreenProvider with ChangeNotifier {
  Duration duration = const Duration();
  Duration position = const Duration();
  int currentIndex = 0;

  void initStateFunction() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        GetAllSongController.currentIndexes = index;
        notifyListeners();
      }
    });
  }
}
