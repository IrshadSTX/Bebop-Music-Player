import 'package:bebop_music/view/HomeScreen/Playlist/playlist_screen.dart';
import 'package:bebop_music/view/HomeScreen/TopBeats/top_beats.dart';
import 'package:bebop_music/view/HomeScreen/favorite/favourite_screen.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/Recent/recent_songs.dart';

class LibraryHome extends StatelessWidget {
  const LibraryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 180,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecentlyPlayed(),
                      ),
                    );
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/topbeats.jpeg'),
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 153, 112, 210),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const Text(
                  'Recent Songs',
                  style: TextStyle(
                      color: Color.fromARGB(255, 153, 112, 210),
                      fontSize: 16,
                      fontFamily: 'Poppins'),
                ),
                // column3
              ],
            ),
            SizedBox(
              height: 10,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavouriteScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/favorite.jpg'),
                          ),
                          border: Border.all(
                            color: const Color.fromARGB(255, 153, 112, 210),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const Text(
                    'Favorites',
                    style: TextStyle(
                        color: Color.fromARGB(255, 153, 112, 210),
                        fontSize: 16,
                        fontFamily: 'Poppins'),
                  ),
                  // column3
                ],
              ),
            ),

            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaylistScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/playlist.jpg'),
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 153, 112, 210),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const Text(
                  'Playlists',
                  style: TextStyle(
                      color: Color.fromARGB(255, 153, 112, 210),
                      fontSize: 16,
                      fontFamily: 'Poppins'),
                ),
                // column3
              ],
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TopBeatsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/micheal.jpeg'),
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 153, 112, 210),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const Text(
                  'Top Beats',
                  style: TextStyle(
                      color: Color.fromARGB(255, 153, 112, 210),
                      fontSize: 16,
                      fontFamily: 'Poppins'),
                ),
                // column3
              ],
            ),
            //your widget items here
          ],
        ),
      ),
    );
  }
}
