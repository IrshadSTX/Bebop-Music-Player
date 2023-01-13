import 'package:bebop_music/model/bebop_model.dart';
import 'package:bebop_music/screens/provider/provider.dart';
import 'package:bebop_music/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(BebopModelAdapter().typeId)) {
    Hive.registerAdapter(BebopModelAdapter());
  }

  await Hive.initFlutter();
  await Hive.openBox('recentSongNotifier');
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox('topBeatsNotifier');
  await Hive.openBox<BebopModel>('playlistDb');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongModelProvider(),
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
