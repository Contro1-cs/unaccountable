import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

Color backgroundgreen = const Color(0xff0D1F22);
Color red = const Color(0xffDA4167);

class _SignupPageState extends State<SignupPage> {
  late Timer timer;
  int start = 0;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundgreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 350,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200),
          ),
        ),
        title: Center(
          child: Image.asset('lib/assets/logo2.png'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }
}
