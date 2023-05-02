import 'package:bebop_music/view/Details/privacypolicy.dart';
import 'package:bebop_music/view/Details/termsnconditions.dart';
import 'package:bebop_music/view/widgets/text_all_widget.dart';
import 'package:flutter/material.dart';

import 'about.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 57, 4, 97),
        centerTitle: true,
        title: const Text('Settings'),
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ));
              },
              child: ListSettings(
                titleText: TextAllWidget.settingAbout,
                yourIcon: Icons.info_outline,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ));
              },
              child: ListSettings(
                titleText: TextAllWidget.settingTermsAndCondition,
                yourIcon: Icons.gavel_rounded,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ));
              },
              child: ListSettings(
                titleText: TextAllWidget.settingPrivacyPolicy,
                yourIcon: Icons.privacy_tip_outlined,
              ),
            ),
            ListSettings(
              titleText: TextAllWidget.settingShare,
              yourIcon: Icons.share_outlined,
            )
          ],
        ),
      ),
    );
  }
}

class ListSettings extends StatelessWidget {
  const ListSettings({
    Key? key,
    required this.titleText,
    required this.yourIcon,
  }) : super(key: key);
  final String titleText;
  final IconData yourIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: const Color.fromARGB(255, 20, 3, 54),
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
        ),
        child: ListTile(
          iconColor: Colors.white,
          selectedColor: Colors.purpleAccent,
          leading: Icon(yourIcon),
          title: Text(
            titleText,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontFamily: 'poppins',
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
