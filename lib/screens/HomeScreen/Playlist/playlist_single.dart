import 'package:bebop_music/screens/HomeScreen/Playlist/playlist_add_songs.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../controller/getRecent_Controller.dart';
import '../../../controller/get_all_song.dart';
import '../../../model/bebop_model.dart';
import '../../MusicPlayer/musicplayer.dart';
import '../../provider/provider.dart';

class PlaylistSingle extends StatefulWidget {
  final BebopModel playlist;
  final int findex;

  const PlaylistSingle(
      {super.key, required this.playlist, required this.findex});

  @override
  State<PlaylistSingle> createState() => _PlaylistSingleState();
}

class _PlaylistSingleState extends State<PlaylistSingle> {
  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 57, 4, 97),
        centerTitle: true,
        title: Text(
          widget.playlist.name.toUpperCase(),
        ),
      ),
      body: SafeArea(
        child: Container(
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
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: ValueListenableBuilder(
                          valueListenable:
                              Hive.box<BebopModel>('playlistDb').listenable(),
                          builder: (BuildContext context, Box<BebopModel> music,
                              Widget? child) {
                            songPlaylist = listPlaylist(
                                music.values.toList()[widget.findex].songId);
                            return songPlaylist.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Add Some Songs',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'poppins'),
                                    ),
                                  )
                                : ListView.builder(
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6, right: 6),
                                        child: Card(
                                          color: const Color.fromARGB(
                                              255, 18, 2, 61),
                                          shadowColor: Colors.purpleAccent,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 132, 0, 255))),
                                          child: ListTile(
                                            iconColor: Colors.white,
                                            selectedColor: Colors.purpleAccent,
                                            leading: QueryArtworkWidget(
                                                id: songPlaylist[index].id,
                                                type: ArtworkType.AUDIO,
                                                nullArtworkWidget: const Icon(
                                                    Icons.music_note)),
                                            title: Text(
                                              songPlaylist[index].title,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              songPlaylist[index].artist!,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontSize: 12,
                                                  color: Colors.blueGrey),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                widget.playlist.deleteData(
                                                    songPlaylist[index].id);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              List<SongModel> newMusicList = [
                                                ...songPlaylist
                                              ];
                                              GetAllSongController.audioPlayer
                                                  .stop();
                                              GetAllSongController.audioPlayer
                                                  .setAudioSource(
                                                      GetAllSongController
                                                          .createSongList(
                                                              newMusicList),
                                                      initialIndex: index);
                                              GetRecentSongController
                                                  .addRecentlyPlayed(
                                                      newMusicList[index].id);

                                              context
                                                  .read<SongModelProvider>()
                                                  .setId(
                                                      newMusicList[index].id);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return PlayerScreen(
                                                  songModelList: songPlaylist,
                                                );
                                              }));
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                    itemCount: songPlaylist.length,
                                  );
                          })),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 57, 4, 97),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SongListAddPage(
                  playlist: widget.playlist,
                );
              },
            ));
          },
          label: const Text('Add Songs')),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
