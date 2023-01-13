import 'package:bebop_music/controller/get_all_song.dart';
import 'package:bebop_music/model/bebop_model.dart';
import 'package:bebop_music/screens/Details/settings.dart';
import 'package:bebop_music/screens/HomeScreen/Playlist/playlistScreen.dart';
import 'package:bebop_music/screens/HomeScreen/favorite/FavButtonPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../db/favourite_db.dart';
import '../widgets/artWork.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key, required this.songModelList}) : super(key: key);
  final List<SongModel> songModelList;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  List<int> topBeatSongList = [];
  int newTopBeatSong = 0;
  Map topBeatSongCounterMap = {0: 0};
  bool _isPlaying = false;
  bool _isLooping = false;
  bool _isShuffling = false;
  List<AudioSource> songList = [];
  int currentIndex = 0;
  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          currentIndex = index;
        });
        GetAllSongController.currentIndexes = index;
      }
    });
    super.initState();
    playSong();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  void playSong() {
    GetAllSongController.audioPlayer.play();
    GetAllSongController.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    GetAllSongController.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        FavoriteDb.favoriteSongs.notifyListeners();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const Text(
                      'NOW PLAYING',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 25,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
                  child: Center(
                    child: Column(
                      children: [
                        const ArtWorkWidget(),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          widget.songModelList[currentIndex].displayNameWOExt,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Color.fromARGB(255, 219, 212, 234)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FavButMusicPlaying(
                                songFavoriteMusicPlaying:
                                    widget.songModelList[currentIndex]),
                            Text(
                              widget.songModelList[currentIndex].artist
                                          .toString() ==
                                      "<unknown>"
                                  ? "Unknown Artist"
                                  : widget.songModelList[currentIndex].artist
                                      .toString(),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 147, 118, 214)),
                            ),
                            IconButton(
                                onPressed: () {
                                  showPlaylistdialog(context);
                                },
                                icon: const Icon(
                                  Icons.playlist_add,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 183, 163, 163),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: Colors.amber,
                                min: const Duration(microseconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                value: _position.inSeconds.toDouble(),
                                max: _duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    changeToSeconds(value.toInt());
                                    value = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              _formatDuration(_duration),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 183, 163, 163),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              iconSize: 50,
                              onPressed: () {
                                if (GetAllSongController
                                    .audioPlayer.hasPrevious) {
                                  GetAllSongController.audioPlayer
                                      .seekToPrevious();
                                }
                                _isPlaying = !_isPlaying;
                              },
                              icon: const Icon(
                                Icons.skip_previous_sharp,
                                color: Colors.amber,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 20, 5, 46),
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                if (GetAllSongController.audioPlayer.playing) {
                                  setState(() {});
                                  await GetAllSongController.audioPlayer
                                      .pause();
                                } else {
                                  await GetAllSongController.audioPlayer.play();
                                  setState(() {});
                                }
                              },
                              child: StreamBuilder<bool>(
                                stream: GetAllSongController
                                    .audioPlayer.playingStream,
                                builder: (context, snapshot) {
                                  bool? playingStage = snapshot.data;
                                  if (playingStage != null && playingStage) {
                                    return const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.pause_circle,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.play_circle,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              iconSize: 50,
                              onPressed: () {
                                if (GetAllSongController.audioPlayer.hasNext) {
                                  GetAllSongController.audioPlayer.seekToNext();
                                }
                              },
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              iconSize: 24,
                              onPressed: () {
                                setState(() {
                                  if (_isShuffling == false) {
                                    GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(true);
                                  } else {
                                    GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(false);
                                  }
                                  _isShuffling = !_isShuffling;
                                });
                              },
                              icon: _isShuffling
                                  ? const Icon(
                                      Icons.shuffle_rounded,
                                      color: Colors.amber,
                                    )
                                  : const Icon(
                                      Icons.shuffle_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                            IconButton(
                                iconSize: 24,
                                onPressed: () {
                                  setState(() {
                                    if (_isLooping) {
                                      GetAllSongController.audioPlayer
                                          .setLoopMode(LoopMode.all);
                                    } else {
                                      GetAllSongController.audioPlayer
                                          .setLoopMode(LoopMode.one);
                                    }
                                    _isLooping = !_isLooping;
                                  });
                                },
                                icon: _isLooping
                                    ? const Icon(
                                        Icons.repeat,
                                        color: Colors.amber,
                                      )
                                    : const Icon(
                                        Icons.repeat,
                                        color: Colors.white,
                                      )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
  }

  showPlaylistdialog(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: const Text(
              "Select your playlist!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color.fromARGB(255, 51, 2, 114),
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
                        ? Center(
                            child: const Positioned(
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
                                color: const Color.fromARGB(255, 51, 2, 114),
                                shadowColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        const BorderSide(color: Colors.white)),
                                child: ListTile(
                                  title: Text(
                                    data.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins'),
                                  ),
                                  trailing: const Icon(
                                    Icons.playlist_add,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    songAddToPlaylist(
                                        widget.songModelList[currentIndex],
                                        data);
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
                    'Add to Playlist',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 51, 2, 114),
                        fontFamily: 'poppins'),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 51, 2, 114),
                        fontFamily: 'poppins'),
                  ))
            ],
          );
        });
  }

  void songAddToPlaylist(SongModel data, datas) {
    if (!datas.isValueIn(data.id)) {
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
