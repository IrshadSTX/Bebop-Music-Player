import 'package:bebop_music/controller/provider/all_song_provider.dart';
import 'package:bebop_music/controller/provider/search_provider.dart';
import 'package:bebop_music/db/model/bebop_model.dart';
import 'package:bebop_music/controller/provider/provider.dart';
import 'package:bebop_music/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(BebopModelAdapter().typeId)) {
    Hive.registerAdapter(BebopModelAdapter());
  }

  await Hive.openBox('recentSongNotifier');
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox('topBeatsNotifier');
  await Hive.openBox<BebopModel>('playlistDb');

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SongModelProvider()),
        ChangeNotifierProvider(create: (context) => AllsongsProvider()),
        ChangeNotifierProvider(create: (context) => SearchScreenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeBop',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, fontFamily: 'PoppinsMedium'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
