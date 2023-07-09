import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/home/home.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/lists/lists.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';
import 'package:unaccountable/widgets/custom_drop_down.dart';
import 'package:unaccountable/widgets/custom_snackbars.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

bool _loading = false;

class _UserInfoPageState extends State<UserInfoPage> {
  String _gender = genders[0];
  TextEditingController age = TextEditingController();
  TextEditingController name = TextEditingController();
  String _country = countries[76];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUserData() {
      return users.doc(uid).set({
        'name': name.text
            .trim()
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'age': age.text
            .trim()
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'country': _country
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
        'gender': _gender
            .split(" ")
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(" "),
      }).then(
        (value) {
          successSnackbar(context, "User Added");
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

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
      ).catchError(
          (error) => errorSnackbar(context, "Failed to add user: $error"));
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundgreen,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Who the fuck are you?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  UserInfoFormField(
                    controller: name,
                    title: 'Name',
                    hint: 'Aaditya Jagdale',
                    inputType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  UserInfoFormField(
                    controller: age,
                    title: 'Age',
                    hint: '21',
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomDropdownButton(
                    title: 'Gender',
                    list: genders,
                    displayedValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  CustomDropdownButton(
                    title: 'Country',
                    list: countries,
                    displayedValue: _country,
                    onChanged: (value) {
                      setState(() {
                        _country = value;
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: 50,
                width: w,
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });
                    addUserData();
                    setState(() {
                      _loading = false;
                    });
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
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Don't exit the app without filling the information",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 50,
                    width: w,
                    decoration: BoxDecoration(
                      color: backgroundgreen,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Okay",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}
