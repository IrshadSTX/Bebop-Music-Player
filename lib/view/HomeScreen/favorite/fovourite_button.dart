import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../db/favourite_db.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavorite)) {
                FavoriteDb.delete(widget.songFavorite.id);
                const snackBar = SnackBar(
                  content: Text('Removed From Favorite'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 20, 5, 46),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                FavoriteDb.add(widget.songFavorite);
                const snackBar = SnackBar(
                  content: Text('Song Added to Favorite'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color.fromARGB(255, 20, 5, 46),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: Icon(
              FavoriteDb.isFavor(widget.songFavorite)
                  ? Icons.favorite
                  : Icons.favorite_outline,
              color: Colors.white,
            ),
          );
        });
  }
}
