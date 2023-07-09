// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/home/home.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';
import 'package:unaccountable/widgets/custom_snackbars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _hidePassword = false;

TextEditingController _authEmail = TextEditingController();
TextEditingController _authPassword = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    _authEmail.text = '';
    _authPassword.text = '';
    _hidePassword = true;
    super.dispose();
  }

  @override
  void initState() {
    _authEmail.text = '';
    _authPassword.text = '';
    _hidePassword = true;
    super.initState();
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    passwordSignIn() async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        successSnackbar(context, 'Login successful');
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const HomePage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errorSnackbar(context, 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          errorSnackbar(context, 'Wrong password provided for that user');
        } else {
          errorSnackbar(context, e.toString());
        }
      }
    }

    return Scaffold(
      backgroundColor: backgroundgreen,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              AnimatedTextKit(
                pause: Duration.zero,
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Continue the hustle!',
                    textStyle: GoogleFonts.poppins(
                      fontSize: 40,
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
            ],
          ),
          Column(
            children: [
              SignUpFormField(
                controller: _emailController,
                title: 'Email',
                hint: 'aaditya@gmail.com',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: w,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Minimum 6 characters',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                          suffixIcon: _hidePassword
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.visibility_off,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                )),
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
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
                if (_emailController.text.trim().isEmpty ||
                    _passwordController.text.trim().isEmpty) {
                  errorSnackbar(context, 'Please enter a email and password');
                } else {
                  passwordSignIn();
                }
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
