import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Bebop'),
        backgroundColor: const Color.fromARGB(255, 57, 4, 97),
      ),
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Welcome to Bebop App, make your life more live. We are dedicated to providing you the very best quality of sound and the music varient,with an emphasis on new features. playlists and favourites,and a rich user experience\n\n Founded in 2023 by Irshad Khaleel P . Bebop app is our first major project with a basic performance of music hub and creates a better versions in future.Bebop gives you the best music experience that you never had. it includes attractivemode of UI\'s and good practices.\n\nIt gives good quality and had increased the settings to power up the system as well as to provide better music rythms.\n\nWe hope you enjoy our music as much as we enjoy offering them to you. If you have any questions or comments, please don\'t hesitate to contact us.\n\nSincerely,\n\nIrshad Khaleel P',
              style: TextStyle(
                  fontFamily: 'poppins', fontSize: 13, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
