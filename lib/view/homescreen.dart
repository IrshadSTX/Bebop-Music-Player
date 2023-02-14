import 'package:bebop_music/controller/Get_Top_Beats_controller.dart';
import 'package:bebop_music/controller/get_all_song.dart';
import 'package:bebop_music/controller/provider/all_song_provider.dart';
import 'package:bebop_music/view/HomeScreen/drawer_screen.dart';

import 'package:bebop_music/view/miniPlayer.dart';

import 'package:bebop_music/controller/provider/provider.dart';

import 'package:bebop_music/view/searchScreen.dart';
import 'package:bebop_music/view/widgets/MenuButton.dart';
import 'package:bebop_music/view/widgets/libraries.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:bebop_music/view/MusicPlayer/musicplayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/getRecent_Controller.dart';
import '../db/favourite_db.dart';

List<SongModel> startSong = [];

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final bool isFavourite = false;

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Error parsing song');
    }
  }

  final _audioQuery = OnAudioQuery();
  final _audioPlayer = AudioPlayer();
  final List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    log("First login");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllsongsProvider>(context, listen: false).requestPermission();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 57, 4, 97),
        centerTitle: true,
        title: const Image(
          image: AssetImage('assets/images/bebop1.png'),
          width: 120,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.width * 2.0,
        child: const NavigationDrawer(),
      ),
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  ' Libraries',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const LibraryHome(),
                const Text(
                  ' Music Lists',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<SongModel>>(
                  future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    if (item.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (item.data!.isEmpty) {
                      return const Center(child: Text("No Songs found"));
                    }
                    startSong = item.data!;
                    if (!FavoriteDb.isInitialized) {
                      FavoriteDb.initialize(item.data!);
                    }
                    GetAllSongController.songscopy = item.data!;
                    return Expanded(
                      child: Stack(
                        children: [
                          ListView.separated(
                            itemBuilder: ((context, index) {
                              allSongs.addAll(item.data!);
                              return Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromARGB(255, 81, 21, 88),
                                  ),
                                ),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    id: item.data![index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note),
                                  ),
                                  title: Text(
                                    item.data![index].displayNameWOExt,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                  iconColor: Colors.white,
                                  subtitle: Text("${item.data![index].artist}",
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.blueGrey,
                                          fontSize: 12)),
                                  trailing: FavoriteMenuButton(
                                      songFavorite: startSong[index]),
                                  onTap: () {
                                    GetAllSongController.audioPlayer
                                        .setAudioSource(
                                            GetAllSongController.createSongList(
                                                item.data!),
                                            initialIndex: index);

                                    GetRecentSongController.addRecentlyPlayed(
                                        item.data![index].id);
                                    GetTopBeatsController.addTopBeats(
                                        item.data![index].id);
                                    context
                                        .read<SongModelProvider>()
                                        .setId(item.data![index].id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayerScreen(
                                          songModelList: item.data!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5,
                            ),
                            itemCount: item.data!.length,
                          ),
                          ValueListenableBuilder(
                              valueListenable: FavoriteDb.favoriteSongs,
                              builder: (BuildContext context,
                                  List<SongModel> music, Widget? child) {
                                return Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      if (GetAllSongController
                                              .audioPlayer.currentIndex !=
                                          null)
                                        Column(
                                          children: const [
                                            MiniPlayer(),
                                          ],
                                        )
                                      else
                                        const SizedBox(),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
