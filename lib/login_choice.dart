import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/user_onboarding/login_page.dart';
import 'package:unaccountable/user_onboarding/signup_dart.dart';

class LoginChoice extends StatefulWidget {
  const LoginChoice({super.key});

  @override
  State<LoginChoice> createState() => _LoginChoiceState();
}

Color backgroundgreen = const Color(0xff0D1F22);
Color red = const Color(0xffDA4167);

class _LoginChoiceState extends State<LoginChoice> {
  late Timer timer;
  int start = 0;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundgreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedTextKit(
            pause: Duration.zero,
            repeatForever: true,
            animatedTexts: [
              ColorizeAnimatedText(
                'Become the hardest motherfucker',
                textStyle: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                colors: [
                  Colors.green,
                  red,
                ],
                speed: const Duration(milliseconds: 1000),
              ),
            ],
          ),
          const SizedBox(height: 200),
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
                'Signup',
                style: GoogleFonts.inter(
                  color: backgroundgreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                'Login',
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
