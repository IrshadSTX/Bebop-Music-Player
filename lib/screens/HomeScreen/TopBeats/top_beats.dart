import 'package:bebop_music/controller/Get_Top_Beats_controller.dart';
import 'package:bebop_music/controller/get_all_song.dart';
import 'package:bebop_music/screens/widgets/MenuButton.dart';
import 'package:bebop_music/screens/MusicPlayer/musicplayer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class TopBeatsScreen extends StatefulWidget {
  const TopBeatsScreen({super.key});

  @override
  State<TopBeatsScreen> createState() => _TopBeatsScreenState();
}

class _TopBeatsScreenState extends State<TopBeatsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var filteredList;

    int duplicateCounter = 0;
    List<SongModel> topBeatsList = [];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 57, 4, 97),
          title: Text('Top Beats'),
          centerTitle: true,
        ),
        body: Container(
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
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: GetTopBeatsController.getTopBeatSongs(),
                      builder: (context, items) {
                        return ValueListenableBuilder(
                            valueListenable:
                                GetTopBeatsController.topBeatsNotifier,
                            builder: (BuildContext context,
                                List<SongModel> value, Widget? child) {
                              if (value.isEmpty) {
                                return Center(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'No Songs found',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                );
                              }

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      child: FutureBuilder<List<SongModel>>(
                                          future: _audioQuery.querySongs(
                                            sortType: null,
                                            orderType: OrderType.ASC_OR_SMALLER,
                                            uriType: UriType.EXTERNAL,
                                            ignoreCase: true,
                                          ),
                                          builder: (context, item) {
                                            if (item.data == null) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            if (item.data!.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  'No Songs Available',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }

                                            for (var i = 0;
                                                i < value.length;
                                                i++) {
                                              duplicateCounter = 0;
                                              for (var j = i + 1;
                                                  j < value.length;
                                                  j++) {
                                                if (value[i] == value[j]) {
                                                  duplicateCounter++;
                                                }
                                                if (duplicateCounter >= 2) {
                                                  filteredList =
                                                      value.toSet().toList();
                                                }
                                              }
                                            }
                                            if (filteredList != null) {
                                              topBeatsList = filteredList;
                                            }
                                            return ListView.separated(
                                              itemBuilder: ((context, index) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 81, 21, 88),
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    iconColor: Colors.white,
                                                    selectedColor:
                                                        Colors.purpleAccent,
                                                    leading: QueryArtworkWidget(
                                                      id: topBeatsList[index]
                                                          .id,
                                                      type: ArtworkType.AUDIO,
                                                      nullArtworkWidget: Icon(Icons
                                                          .music_note_rounded),
                                                    ),
                                                    title: Text(
                                                      topBeatsList[index]
                                                          .displayNameWOExt,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontFamily: 'poppins',
                                                          color: Colors.white),
                                                    ),
                                                    subtitle: Text(
                                                      topBeatsList[index]
                                                                  .artist ==
                                                              "<unknown>"
                                                          ? "Unknown Artist"
                                                          : topBeatsList[index]
                                                              .artist
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontFamily: 'poppins',
                                                          fontSize: 12,
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                    trailing:
                                                        FavoriteMenuButton(
                                                      songFavorite:
                                                          topBeatsList[index],
                                                    ),
                                                    onTap: () {
                                                      GetAllSongController
                                                          .audioPlayer
                                                          .setAudioSource(
                                                              GetAllSongController
                                                                  .createSongList(
                                                                      topBeatsList),
                                                              initialIndex:
                                                                  index);
                                                      GetAllSongController
                                                          .audioPlayer
                                                          .play();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PlayerScreen(
                                                                    songModelList:
                                                                        GetAllSongController
                                                                            .playingSong),
                                                          ));
                                                    },
                                                  ),
                                                );
                                              }),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 5,
                                              ),
                                              itemCount: topBeatsList.length,
                                            );
                                          })),
                                ),
                              );
                            });
                      })
                ],
              ),
            ],
          ),
        ));
  }
}
