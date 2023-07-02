import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/user_onboarding/signup_dart.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

Color backgroundgreen = const Color(0xff0D1F22);
Color red = const Color(0xffDA4167);
Color lightGreen = const Color(0xff037971);

class _LandingPageState extends State<LandingPage> {
  late Timer timer;
  int start = 0;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundgreen,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 350,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(100),
            ),
          ),
          title: Column(
            children: [
              Center(
                child: Image.asset('lib/assets/logo2.png'),
              ),
              const Text(
                "Get your ass off that couch\nmotherfucker!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              AnimatedTextKit(
                pause: Duration.zero,
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'unaccountable',
                    textStyle: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      const Color(0xff037971),
                      red,
                    ],
                    speed: const Duration(milliseconds: 1000),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: const Text(
                  'Being honest with yourself is the first step towards improvement',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Container(
            height: 50,
            width: w,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupPage(),
                  ),
                );
              },
              child: Text(
                'Get shit done!',
                style: GoogleFonts.inter(
                  color: backgroundgreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
