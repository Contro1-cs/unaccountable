import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';
import 'package:unaccountable/user_onboarding/user_info.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundgreen,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          toolbarHeight: 150,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Get your ass up and start\nworking motherfucker!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black,
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 1),
          Column(
            children: [
              SignUpFormField(
                controller: emailController,
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
                      controller: passwordController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 50,
            width: w,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfo(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Sign up',
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
