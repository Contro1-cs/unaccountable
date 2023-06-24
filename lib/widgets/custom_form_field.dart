import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: const TextField(
        decoration: InputDecoration(),
      ),
    );
  }
}
