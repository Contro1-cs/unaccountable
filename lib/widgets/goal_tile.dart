import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

label(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(1000),
      color: const Color(0xff484848),
    ),
    child: Text(
      text,
      style: GoogleFonts.inter(color: Colors.white),
    ),
  );
}

goalTile(context, String title, String tag, String deadline) {
  var w = MediaQuery.of(context).size.width;
  return Container(
    width: w,
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xffDEFFFF),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title.length <= 13 ? title : '${title.substring(0, 13)}...',
              style: GoogleFonts.inter(
                color: const Color(0xff484848),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            label(tag)
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 10,
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 40,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100 - 40,
                      child: Container(),
                    )
                  ],
                ),
              ),
            ),
            Text(
              '40%',
              style: GoogleFonts.inter(color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff484848),
              ),
              alignment: Alignment.center,
              child: Text(
                'Deadline: $deadline',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '121 days left',
              style: GoogleFonts.inter(color: const Color(0xffEF3350)),
            )
          ],
        )
      ],
    ),
  );
}
