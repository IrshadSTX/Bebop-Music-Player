import 'package:bebop_music/model/bebop_model.dart';
import 'package:bebop_music/screens/HomeScreen/Playlist/playlist_single.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../db/playlist_db.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<BebopModel>('playlistDb').listenable(),
        builder:
            (BuildContext context, Box<BebopModel> musicList, Widget? child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              label: const Text('Add'),
              icon: const Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 57, 4, 97),
              onPressed: () {
                const snackBar = SnackBar(
                  content: Text(
                    'playlist created',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(milliseconds: 1500),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                newplaylist(context, _formKey);
              },
            ),
            appBar: AppBar(
              title: Text('Playlists'),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 57, 4, 97),
            ),
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
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                              itemBuilder: ((context, index) {
                                final data = musicList.values.toList()[index];

                                return ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box<BebopModel>('playlistDb')
                                          .listenable(),
                                  builder: (BuildContext context,
                                      Box<BebopModel> musicList,
                                      Widget? child) {
                                    return Card(
                                      color:
                                          const Color.fromARGB(255, 18, 2, 61),
                                      shadowColor: Colors.purpleAccent,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 132, 0, 255),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlaylistSingle(
                                                  playlist: data,
                                                  findex: index,
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 80,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  TextScroll(
                                                    data.name.toUpperCase(),
                                                    mode:
                                                        TextScrollMode.bouncing,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        fontFamily: 'poppins'),
                                                  ),
                                                  PopupMenuButton(
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white,
                                                    ),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        value: 1,
                                                        child: Text('Edit'),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 2,
                                                        child: Text('delete'),
                                                      )
                                                    ],
                                                    onSelected: (value) {
                                                      if (value == 1) {
                                                        EditPlaylistName(
                                                            context,
                                                            data,
                                                            index);
                                                      } else if (value == 2) {
                                                        DeletePlaylist(context,
                                                            musicList, index);
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                              itemCount: musicList.length,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> EditPlaylistName(
      BuildContext context, BebopModel data, int index) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Color.fromARGB(255, 52, 6, 105),
        children: [
          SimpleDialogOption(
            child: Text(
              "Edit Playlist '${data.name}'",
              style: const TextStyle(
                  fontFamily: 'poppins',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SimpleDialogOption(
            child: Form(
              key: _formKey,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: nameController,
                maxLength: 15,
                decoration: InputDecoration(
                    counterStyle:
                        TextStyle(color: Colors.white, fontFamily: 'poppins'),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.only(left: 15, top: 5)),
                style: const TextStyle(
                    fontFamily: 'poppins',
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your playlist name";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.purpleAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      return;
                    } else {
                      final playlistName = BebopModel(name: name, songId: []);
                      PlaylistDb.editList(index, playlistName);
                    }
                    nameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.purpleAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> DeletePlaylist(
      BuildContext context, Box<BebopModel> musicList, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 52, 6, 105),
          title: const Text(
            'Delete Playlist',
            style: TextStyle(color: Colors.white, fontFamily: 'poppins'),
          ),
          content: const Text('Are you sure you want to delete this playlist?',
              style: TextStyle(color: Colors.white, fontFamily: 'poppins')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No',
                  style: TextStyle(
                      color: Colors.purpleAccent, fontFamily: 'poppins')),
            ),
            TextButton(
              onPressed: () {
                musicList.deleteAt(index);
                Navigator.pop(context);
                const snackBar = SnackBar(
                  backgroundColor: Colors.black,
                  content: Text(
                    'Playlist is deleted',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(milliseconds: 350),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Yes',
                  style: TextStyle(
                      color: Colors.purpleAccent, fontFamily: 'poppins')),
            ),
          ],
        );
      },
    );
  }
}

Future newplaylist(BuildContext context, formKey) {
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Color.fromARGB(255, 132, 0, 255),
      children: [
        const SimpleDialogOption(
          child: Text(
            'Enter Playlist Name',
            style: TextStyle(
                fontFamily: 'poppins',
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: formKey,
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: nameController,
              maxLength: 15,
              decoration: InputDecoration(
                  counterStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'poppins'),
                  fillColor:
                      Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.only(left: 15, top: 5)),
              style: const TextStyle(
                  fontFamily: 'poppins',
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your playlist name";
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveButtonPressed(context);
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> saveButtonPressed(context) async {
  final name = nameController.text.trim();
  final music = BebopModel(name: name, songId: []);
  final datas = PlaylistDb.playlistDb.values.map((e) => e.name.trim()).toList();
  if (name.isEmpty) {
    return;
  } else if (datas.contains(music.name)) {
    const snackbar3 = SnackBar(
        duration: Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: Text(
          'playlist already exist',
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar3);
    Navigator.of(context).pop();
  } else {
    PlaylistDb.addPlaylist(music);
    const snackbar4 = SnackBar(
        duration: Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: Text(
          'playlist created successfully',
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    Navigator.pop(context);
    nameController.clear();
  }
}
