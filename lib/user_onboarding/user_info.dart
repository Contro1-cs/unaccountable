import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/home/home.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/lists/lists.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';
import 'package:unaccountable/widgets/custom_drop_down.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String _gender = genders[0];
  TextEditingController age = TextEditingController();
  TextEditingController name = TextEditingController();
  String _country = countries[76];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
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
