import 'package:bebop_music/model/bebop_model.dart';
import 'package:bebop_music/screens/HomeScreen/Playlist/playlistScreen.dart';
import 'package:bebop_music/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../db/favourite_db.dart';

class FavoriteMenuButton extends StatefulWidget {
  const FavoriteMenuButton(
      {super.key, required this.songFavorite, this.findex});
  final SongModel songFavorite;
  final findex;
  State<FavoriteMenuButton> createState() => _FavoriteMenuButtonState();
}

bool isAddedToPlaylist = false;

class _FavoriteMenuButtonState extends State<FavoriteMenuButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(
                  FavoriteDb.isFavor(widget.songFavorite)
                      ? 'Remove from favourites'
                      : 'Add to favourite',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'Poppins',
                      fontSize: 13)),
              onTap: () {
                if (FavoriteDb.isFavor(widget.songFavorite)) {
                  FavoriteDb.delete(widget.songFavorite.id);
                  const snackBar = SnackBar(
                    content: Text('Removed From Favorite'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color.fromARGB(255, 138, 0, 0),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  FavoriteDb.add(widget.songFavorite);
                  const snackBar = SnackBar(
                    content: Text('Song Added to Favorite'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color.fromARGB(255, 0, 95, 19),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                FavoriteDb.favoriteSongs.notifyListeners();
              },
            ),
            const PopupMenuItem(
              child: Text(
                'Add to playlists',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'Poppins',
                    fontSize: 13),
              ),
              value: 2,
              // value: PlaylistScreen(),
            )
          ],
          onSelected: (value) {
            if (value == 2) {
              showPlaylistdialog(context);
            }
          },
          color: Color.fromARGB(255, 37, 5, 92),
          elevation: 2,
        );
      },
    );
  }

  showPlaylistdialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              textAlign: TextAlign.center,
              "Select your playlist!",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 2, 114),
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<BebopModel>('playlistDb').listenable(),
                  builder: (BuildContext context, Box<BebopModel> musicList,
                      Widget? child) {
                    return Hive.box<BebopModel>('playlistDb').isEmpty
                        ? const Center(
                            child: Positioned(
                              right: 30,
                              left: 30,
                              bottom: 50,
                              child: Text('No Playlist found!',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'poppins')),
                            ),
                          )
                        : ListView.builder(
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final data = musicList.values.toList()[index];

                              return Card(
                                color: Color.fromARGB(255, 51, 2, 114),
                                shadowColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        const BorderSide(color: Colors.white)),
                                child: ListTile(
                                  title: Text(
                                    data.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins'),
                                  ),
                                  trailing: isAddedToPlaylist
                                      ? Icon(
                                          Icons.playlist_add_check,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.playlist_add,
                                          color: Colors.white,
                                        ),
                                  onTap: () {
                                    songAddToPlaylist(startSong[index], data);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaylistScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Add Playist',
                    style: TextStyle(
                        color: Color.fromARGB(255, 51, 2, 114),
                        fontFamily: 'poppins'),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                        color: Color.fromARGB(255, 51, 2, 114),
                        fontFamily: 'poppins'),
                  ))
            ],
          );
        });
  }

  void songAddToPlaylist(SongModel data, datas) {
    if (!datas.isValueIn(data.id)) {
      setState(() {
        isAddedToPlaylist = true;
      });
      datas.add(data.id);
      const snackbar1 = SnackBar(
          duration: Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song added to Playlist',
            style: TextStyle(color: Colors.greenAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar1);
    } else {
      setState(() {
        isAddedToPlaylist = false;
      });
      const snackbar2 = SnackBar(
          duration: Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song already added to this playlist',
            style: TextStyle(color: Colors.redAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
    }
  }
}
