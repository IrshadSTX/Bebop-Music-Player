import 'package:bebop_music/screens/homescreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/bebop1.png'),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(25),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    minimumSize: Size(170, 45),
                    textStyle: TextStyle(fontSize: 18),
                    foregroundColor: Color.fromARGB(255, 135, 195, 240),
                    side: BorderSide(
                        width: 3, color: Color.fromARGB(255, 108, 175, 229)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
