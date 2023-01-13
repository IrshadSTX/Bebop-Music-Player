import 'package:bebop_music/controller/getRecent_Controller.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../controller/get_all_song.dart';
import 'MusicPlayer/musicplayer.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

bool isPlaying = false;

class _MiniPlayerState extends State<MiniPlayer> {
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songModelList: GetAllSongController.playingSong,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.cyan, width: 2),
              ),
              color: Color.fromARGB(255, 2, 3, 61)),
          height: 100,
          width: MediaQuery.of(context).size.width * 1.0,
          child: Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  width: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isPlaying
                          ? Text(
                              GetAllSongController
                                  .playingSong[GetAllSongController
                                      .audioPlayer.currentIndex!]
                                  .displayNameWOExt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                  fontSize: 14),
                            )
                          : TextScroll(
                              GetAllSongController
                                  .playingSong[GetAllSongController
                                      .audioPlayer.currentIndex!]
                                  .displayNameWOExt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                  fontSize: 14),
                            ),
                      Text(
                        GetAllSongController
                                    .playingSong[GetAllSongController
                                        .audioPlayer.currentIndex!]
                                    .artist
                                    .toString() ==
                                "<unknown>"
                            ? "Unknown Artist"
                            : GetAllSongController
                                .playingSong[GetAllSongController
                                    .audioPlayer.currentIndex!]
                                .artist
                                .toString(),
                        style: const TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 10,
                            color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 32,
                  onPressed: () async {
                    if (GetAllSongController.audioPlayer.hasPrevious) {
                      await GetAllSongController.audioPlayer.seekToPrevious();
                      await GetAllSongController.audioPlayer.play();
                    } else {
                      await GetAllSongController.audioPlayer.play();
                    }
                  },
                  icon: const Icon(Icons.skip_previous_outlined),
                  color: Colors.white,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 133, 23, 120),
                      shape: const CircleBorder()),
                  onPressed: () async {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    if (GetAllSongController.audioPlayer.playing) {
                      await GetAllSongController.audioPlayer.pause();
                      setState(() {});
                    } else {
                      await GetAllSongController.audioPlayer.play();
                      setState(() {});
                    }
                  },
                  child: StreamBuilder<bool>(
                    stream: GetAllSongController.audioPlayer.playingStream,
                    builder: (context, snapshot) {
                      bool? playingStage = snapshot.data;
                      if (playingStage != null && playingStage) {
                        return const Icon(
                          Icons.pause_circle,
                          color: Colors.white,
                          size: 45,
                        );
                      } else {
                        return const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 45,
                        );
                      }
                    },
                  ),
                ),
                IconButton(
                  iconSize: 35,
                  onPressed: () async {
                    if (GetAllSongController.audioPlayer.hasNext) {
                      await GetAllSongController.audioPlayer.seekToNext();
                      await GetAllSongController.audioPlayer.play();
                    } else {
                      await GetAllSongController.audioPlayer.play();
                    }
                  },
                  icon: const Icon(
                    Icons.skip_next_outlined,
                    size: 32,
                  ),
                  color: Colors.white,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
