import 'package:bebop_music/screens/MusicPlayer/musicplayer.dart';
import 'package:bebop_music/screens/homescreen.dart';
import 'package:bebop_music/screens/provider/provider.dart';

import 'package:bebop_music/screens/widgets/MenuButton.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/get_all_song.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final audioPlayer = AudioPlayer();
final audioQuery = OnAudioQuery();

@override
class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    songsLoading();
  }

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredText.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 5, 46),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color.fromARGB(255, 5, 3, 69),
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => updateList(value),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 57, 4, 97),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Song',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              prefixIconColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '   Results',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'poppins'),
                  ),
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
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note),
                                ),
                                title: Text(
                                  foundSongs[index].displayNameWOExt,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'poppins',
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  foundSongs[index].artist.toString() ==
                                          "<unknown>"
                                      ? "Unknown Artist"
                                      : foundSongs[index].artist.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 12,
                                      color: Colors.blueGrey),
                                ),
                                trailing: FavoriteMenuButton(
                                    songFavorite: startSong[index]),
                                onTap: () {
                                  GetAllSongController.audioPlayer
                                      .setAudioSource(
                                          GetAllSongController.createSongList(
                                              foundSongs),
                                          initialIndex: index);
                                  GetAllSongController.audioPlayer.play();
                                  context
                                      .read<SongModelProvider>()
                                      .setId(foundSongs[index].id);
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
                        ))
                      : const Center(
                          child: Text(
                            'No search result found',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              )),
            ),
          ),
        ));
  }

  void songsLoading() async {
    allsongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    foundSongs = allsongs;
  }
}
