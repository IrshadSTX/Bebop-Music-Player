import 'package:bebop_music/controller/provider/search_provider.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchScreenProvider>(context, listen: false).songsLoading();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 5, 46),
        body: Container(
          width: double.infinity,
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Expanded(
                        child: TextField(
                          onChanged: (value) =>
                              Provider.of<SearchScreenProvider>(context,
                                      listen: false)
                                  .updateList(value),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 57, 4, 97),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Song',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              prefixIconColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '   Results',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'poppins'),
                  ),
                  Consumer<SearchScreenProvider>(
                      builder: (context, value, child) {
                    return value.showListView() ?? Container();
                  }),
                ],
              )),
            ),
          ),
        ));
  }
}
