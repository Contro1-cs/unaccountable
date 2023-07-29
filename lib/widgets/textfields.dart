import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFormField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final TextInputType inputType;
  const ProfileFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.inputType,
  });

  @override
  State<ProfileFormField> createState() => _ProfileFormFieldState();
}

class _ProfileFormFieldState extends State<ProfileFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            controller: widget.controller,
            keyboardType: widget.inputType,
            maxLength: widget.inputType == TextInputType.number ? 2 : 100,
            decoration: const InputDecoration(
              counterText: '',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
