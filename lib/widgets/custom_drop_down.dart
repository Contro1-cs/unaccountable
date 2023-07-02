import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/landing_page.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends StatelessWidget {
  final String title;
  final List list;
  final String displayedValue;
  var onChanged;

  CustomDropdownButton({
    required this.title,
    required this.list,
    required this.displayedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            underline: Container(
              color: Colors.white,
              height: 1,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            isExpanded: true,
            value: displayedValue,
            dropdownColor: const Color(0xff114048),
            hint: Text(
              title,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onChanged: onChanged,
            items: list.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
