import 'package:bebop_music/controller/get_all_song.dart';
import 'package:bebop_music/view/MusicPlayer/musicplayer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SearchScreenProvider with ChangeNotifier {
  late List<SongModel> allSongs;
  List<SongModel> foundSongs = [];
  final OnAudioQuery audioQueryObject = OnAudioQuery();
  final AudioPlayer searchPageAudioPlayer = AudioPlayer();

  void fetchingAllSongsAndAssigningToFoundSongs() async {
    allSongs = await audioQueryObject.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    foundSongs = allSongs;
    notifyListeners();
  }

  void runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    }
    if (enteredKeyword.isNotEmpty) {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trim());
      }).toList();
    }
    foundSongs = results;
    notifyListeners();
  }

  Widget? showListView() {
    if (foundSongs.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.all(5),
          itemBuilder: ((context, index) {
            return ListTile(
              leading: QueryArtworkWidget(
                id: foundSongs[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.music_note)),
              ),
              title: Text(
                foundSongs[index].title,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'poppins',
                    fontSize: 14,
                    overflow: TextOverflow.clip),
              ),
              subtitle: Text(
                maxLines: 1,
                foundSongs[index].artist.toString() == '<unknown>'
                    ? 'UNKNOWN ARTIST'
                    : foundSongs[index].artist.toString(),
                style: const TextStyle(
                    fontFamily: 'poppins', fontSize: 10, color: Colors.grey),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onTap: () {
                GetAllSongController.audioPlayer.setAudioSource(
                    GetAllSongController.createSongList(foundSongs),
                    initialIndex: index);
                GetAllSongController.audioPlayer.play();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return PlayerScreen(
                        songModelList: foundSongs,
                      );
                    }),
                  ),
                );
              },
            );
          }),
          separatorBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
          itemCount: foundSongs.length);
    } else {
      return null;
    }
  }
}
