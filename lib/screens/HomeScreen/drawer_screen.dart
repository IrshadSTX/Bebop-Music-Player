import 'package:bebop_music/screens/Details/settings.dart';
import 'package:bebop_music/screens/HomeScreen/TopBeats/top_beats.dart';
import 'package:flutter/material.dart';

import 'Playlist/playlistScreen.dart';
import 'favorite/favouriteScreen.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30, left: 20),
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image(
                  width: 120,
                  image: AssetImage('assets/images/bebop1.png'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.my_library_music_outlined),
              title: const Text('Top Beats'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TopBeatsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add_check),
              title: const Text('Playlists'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlaylistScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_outlined),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouriteScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
