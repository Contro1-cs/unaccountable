import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpFormField extends StatelessWidget {
  TextEditingController controller;
  String title;
  String hint;
  TextInputType inputType;
  SignUpFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            title,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
            cursorColor: Colors.white,
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.white),
            keyboardType: inputType,
          ),
        )
      ],
    );
  }
}

class UserInfoFormField extends StatelessWidget {
  TextEditingController controller;
  String title;
  String hint;
  TextInputType inputType;
  UserInfoFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: w,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
            cursorColor: Colors.white,
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.white),
            keyboardType: inputType,
          ),
        )
      ],
    );
  }
}
