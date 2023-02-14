import 'package:bebop_music/controller/provider/search_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchScreenProvider>(context, listen: false)
        .fetchingAllSongsAndAssigningToFoundSongs();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Color.fromARGB(255, 5, 3, 69),
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 15, 35, 0),
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    filled: true,
                    fillColor: Colors.white.withOpacity(.5),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search Song here..',
                    hintStyle: const TextStyle(
                        fontFamily: 'UbuntuCondensed', color: Colors.white),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: ((value) {
                    Provider.of<SearchScreenProvider>(context, listen: false)
                        .runFilter(value);
                  }),
                ),
              )
            ],
          ),
          body: Consumer<SearchScreenProvider>(
            builder: (context, value, child) {
              return value.showListView() ?? Container();
            },
          )),
    );
  }
}
