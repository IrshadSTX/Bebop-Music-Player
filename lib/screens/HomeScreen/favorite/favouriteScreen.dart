import 'package:bebop_music/db/favourite_db.dart';
import 'package:bebop_music/screens/MusicPlayer/musicplayer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controller/get_all_song.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: const Color.fromARGB(255, 57, 4, 97),
                title: const Text('Favorites'),
              ),
              body: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  // height: double.infinity,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: FavoriteDb.favoriteSongs,
                            builder: (BuildContext ctx,
                                List<SongModel> favoriteData, Widget? child) {
                              if (favoriteData.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Favourite Songs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 5,
                                        ),
                                        itemBuilder: ((context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6, right: 6),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2,
                                                  color: const Color.fromARGB(
                                                      255, 81, 21, 88),
                                                ),
                                              ),
                                              child: ListTile(
                                                iconColor: Colors.white,
                                                selectedColor:
                                                    Colors.purpleAccent,
                                                leading: QueryArtworkWidget(
                                                  id: favoriteData[index].id,
                                                  type: ArtworkType.AUDIO,
                                                  nullArtworkWidget: const Icon(
                                                      Icons.music_note),
                                                ),
                                                title: Text(
                                                  favoriteData[index]
                                                      .displayNameWOExt,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontFamily: 'poppins',
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  favoriteData[index]
                                                      .artist
                                                      .toString(),
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontFamily: 'poppins',
                                                      fontSize: 12,
                                                      color: Colors.blueGrey),
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.favorite_rounded,
                                                    color: Color.fromARGB(
                                                        255, 108, 10, 183),
                                                  ),
                                                  onPressed: () {
                                                    FavoriteDb.favoriteSongs
                                                        .notifyListeners();
                                                    FavoriteDb.delete(
                                                        favoriteData[index].id);
                                                    const snackbar = SnackBar(
                                                      content: Text(
                                                        'Song Deleted From your Favourites',
                                                      ),
                                                      duration:
                                                          Duration(seconds: 1),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 20, 5, 46),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackbar);
                                                  },
                                                ),
                                                onTap: () {
                                                  List<SongModel> favoriteList =
                                                      [...favoriteData];
                                                  GetAllSongController
                                                      .audioPlayer
                                                      .stop();
                                                  GetAllSongController
                                                      .audioPlayer
                                                      .setAudioSource(
                                                          GetAllSongController
                                                              .createSongList(
                                                                  favoriteList),
                                                          initialIndex: index);
                                                  GetAllSongController
                                                      .audioPlayer
                                                      .play();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlayerScreen(
                                                                songModelList:
                                                                    favoriteList),
                                                      ));
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                        itemCount: favoriteData.length,
                                      )),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
