import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/home/list_page.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/lists/lists.dart';
import 'package:unaccountable/widgets/custom_form_field.dart';

String mockText = '';
bool mock = false;
int freqIndex = 0;

late Timer _timer;
int _secondsLeft = 5;
bool timerStarted = false;

void goalBottomSheet({
  required BuildContext context,
  required TextEditingController goalController,
  required String startDateController,
  required String endDateController,
  required String freqController,
}) {
  String today = getCurrentDate();

  mockingText() {
    calculateDateDifferenceInDays(startDateController, endDateController);
    if (startDateController != today) {
      mockText = 'Why not start from today bitch?';
    } else if (calculateDateDifferenceInDays(
          startDateController,
          endDateController,
        ) <=
        30) {
      mockText = 'Thats not even a month pyssy!';
    } else if (freqController != frequencyList[0]) {
      mockText = "Can we try to do it ${frequencyList[freqIndex - 1]}?";
    } else {
      mockText = '';
    }
  }

  showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    context: context,
    isScrollControlled: true,
    backgroundColor: backgroundgreen,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom), // Add padding for the keyboard
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: StatefulBuilder(
              builder: (context, setState) {
                void startTimer() {
                  timerStarted = true;
                  _secondsLeft = 5;
                  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    if (_secondsLeft > 0) {
                      setState(() {
                        _secondsLeft--;
                      });
                    } else {
                      setState(() {
                        timerStarted = false;
                        timer.cancel();
                      });
                    }
                  });
                }

                void stopTimer() {
                  setState(() {
                    timerStarted = false;
                    _timer.cancel();
                  });
                }

                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          ' 💪 Set a new goal',
                          style: GoogleFonts.inter(
                            color: const Color(0xffffffff),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      setGoalTile(context, goalController),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'Start date',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: lightGreen),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextButton.icon(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        ).then((value) {
                                          if (value == null) {
                                            return;
                                          }
                                          setState(
                                            () {
                                              startDateController =
                                                  '${_formatDigits(value.day)}-${_formatDigits(value.month)}-${_formatDigits(value.year)}';
                                            },
                                          );

                                          return null;
                                        }).whenComplete(() => mockingText());
                                      },
                                      icon: Icon(
                                        Icons.calendar_month,
                                        color: lightGreen,
                                      ),
                                      label: Text(
                                        startDateController,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'End date',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: lightGreen),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextButton.icon(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        ).then((value) {
                                          if (value == null) {
                                            return;
                                          }
                                          setState(
                                            () {
                                              endDateController =
                                                  '${_formatDigits(value.day)}-${_formatDigits(value.month)}-${_formatDigits(value.year)}';
                                            },
                                          );

                                          return null;
                                        }).whenComplete(() {
                                          calculateDateDifferenceInDays(
                                            startDateController,
                                            endDateController,
                                          );
                                          mockingText();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.calendar_month,
                                        color: lightGreen,
                                      ),
                                      label: Text(
                                        endDateController,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: lightGreen),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              dropdownColor: backgroundgreen,
                              value: freqController,
                              isExpanded: true,
                              style: GoogleFonts.poppins(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  mockingText();
                                  freqController = value!;
                                  if (freqController == frequencyList[0]) {
                                    freqIndex = 0;
                                  } else if (freqController ==
                                      frequencyList[1]) {
                                    freqIndex = 1;
                                  } else if (freqController ==
                                      frequencyList[2]) {
                                    freqIndex = 2;
                                  } else if (freqController ==
                                      frequencyList[3]) {
                                    freqIndex = 3;
                                  }
                                });
                              },
                              items: frequencyList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          mockText,
                          style: GoogleFonts.poppins(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mockingText();
                            startTimer();
                          });
                        },
                        child: AnimatedContainer(
                          curve: Curves.decelerate,
                          duration: const Duration(seconds: 1),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 5 - _secondsLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.red,
                                        ),
                                      )),
                                  Expanded(
                                    flex: _secondsLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  timerStarted
                                      ? _secondsLeft.toString()
                                      : 'Get Started',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    mockText = '';
    timerStarted = false;
  });
}

String _formatDigits(int digits) {
  return digits < 10 ? '0$digits' : '$digits';
}
