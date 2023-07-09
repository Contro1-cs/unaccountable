// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';
import 'package:unaccountable/user_onboarding/user_info.dart';
import 'package:unaccountable/widgets/custom_snackbars.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

TextEditingController _authEmailController = TextEditingController();
TextEditingController _authPasswordController = TextEditingController();
bool _loading = false;

class _SignupPageState extends State<SignupPage> {
  bool _hidePassword = true;
  @override
  void dispose() {
    _authEmailController.text = '';
    _authPasswordController.text = '';
    super.dispose();
  }

  @override
  void initState() {
    _authEmailController.text = '';
    _authPasswordController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    emailRegisteration() async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _authEmailController.text.trim(),
          password: _authPasswordController.text.trim(),
        );

        successSnackbar(context, 'Login successful');
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const UserInfoPage();
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
        if (e.code == 'weak-password') {
          errorSnackbar(context, 'Please enter a stronger password');
        } else if (e.code == 'email-already-in-use') {
          errorSnackbar(
              context, 'This user already exists. Please Login to continue');
        }
      } catch (e) {
        errorSnackbar(context, e.toString());
      }
    }

    return Scaffold(
        backgroundColor: backgroundgreen,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 70),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Get off that bed fucker!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 120),
              Column(
                children: [
                  SignUpFormField(
                    controller: _authEmailController,
                    title: 'Email',
                    hint: 'aaditya@gmail.com',
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Minimum 6 characters',
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
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
                          controller: _authPasswordController,
                          style: GoogleFonts.poppins(color: Colors.white),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Container(
                height: 50,
                width: w,
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (_authEmailController.text.isNotEmpty &&
                        _authPasswordController.text.trim().isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });
                      emailRegisteration();
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      errorSnackbar(context, 'Enter email and password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Sign up',
                          style: GoogleFonts.inter(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                ),
              )
            ],
          ),
        ));
  }
}
