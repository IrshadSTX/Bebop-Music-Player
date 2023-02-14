import 'package:bebop_music/controller/get_all_song.dart';
import 'package:bebop_music/screens/MusicPlayer/musicplayer.dart';
import 'package:bebop_music/screens/homescreen.dart';
import 'package:bebop_music/screens/widgets/MenuButton.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SearchScreenProvider with ChangeNotifier {
  List<SongModel> allsongs = [];
  List<SongModel> foundSongs = [];

  final OnAudioQuery audioQueryObject = OnAudioQuery();

  void songsLoading() async {
    allsongs = await audioQueryObject.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    foundSongs = allsongs;
    notifyListeners();
  }

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    }
    if (enteredText.isNotEmpty) {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredText.toLowerCase().trimRight()))
          .toList();
    }

    foundSongs = results;
    notifyListeners();
  }

  Widget? showListView() {
    foundSongs.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return Card(
                  color: Colors.black,
                  shadowColor: Colors.purpleAccent,
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(
                    color: Color.fromARGB(255, 153, 112, 210),
                  )),
                  child: ListTile(
                    iconColor: Colors.white,
                    selectedColor: Colors.purpleAccent,
                    leading: QueryArtworkWidget(
                      id: foundSongs[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note),
                    ),
                    title: Text(
                      foundSongs[index].displayNameWOExt,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'poppins',
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      foundSongs[index].artist.toString() == "<unknown>"
                          ? "Unknown Artist"
                          : foundSongs[index].artist.toString(),
                      style: const TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Colors.blueGrey),
                    ),
                    trailing:
                        FavoriteMenuButton(songFavorite: startSong[index]),
                    onTap: () {
                      GetAllSongController.audioPlayer.setAudioSource(
                          GetAllSongController.createSongList(foundSongs),
                          initialIndex: index);
                      GetAllSongController.audioPlayer.play();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PlayerScreen(
                          songModelList: foundSongs,
                        );
                      }));
                    },
                  ),
                );
              }),
              itemCount: foundSongs.length,
            ),
          )
        : const Center(
            child: Text(
              'No search result found',
              style: TextStyle(color: Colors.white),
            ),
          );
    return null;
  }
}
