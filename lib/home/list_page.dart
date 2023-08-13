import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/lists/lists.dart';
import 'package:unaccountable/user_onboarding/user_info.dart';
import 'package:unaccountable/widgets/bottom_sheet.dart';
import 'package:unaccountable/widgets/goal_tile.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

TextEditingController _goalController = TextEditingController();
String _startDateController = '00-00-0000';
String _endDateController = '00-00-0000';
String _frequencyController = frequencyList[0];

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    _startDateController = getCurrentDate();
    _endDateController = getCurrentDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final users = FirebaseFirestore.instance.collection('users');

    int daysLeft;
    double progress;

    String _convertToValidDateFormat(String dateString) {
      List<String> parts = dateString.split("-");
      String day = parts[0];
      String month = parts[1];
      String year = parts[2];
      return "$year-$month-$day";
    }

    int calculateDateDifferenceInDays(String today, String deadline) {
      DateTime date1 = DateTime.parse(_convertToValidDateFormat(today));
      DateTime date2 = DateTime.parse(_convertToValidDateFormat(deadline));

      Duration difference = date2.difference(date1);
      return difference.inDays;
    }

    String getCurrentDate() {
      String formatDigits(int digits) {
        return digits < 10 ? '0$digits' : '$digits';
      }

      DateTime now = DateTime.now();
      String currentDate =
          '${formatDigits(now.day)}-${formatDigits(now.month)}-${formatDigits(now.year)}';
      return currentDate;
    }

    calculateDaysLeft(String start, String deadline) {
      String today = getCurrentDate();
      return calculateDateDifferenceInDays(today, deadline);
    }

    calculateProgress(String start, String deadline) {
      String today = getCurrentDate();
      int total = calculateDateDifferenceInDays(start, deadline);
      daysLeft = calculateDateDifferenceInDays(today, deadline);
      int diff = total - daysLeft;
      return (diff * 100) / total;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundgreen,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundgreen,
        title: Text(
          ' Goals',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffDEFFFF),
        onPressed: () {
          goalBottomSheet(
            context: context,
            goalController: _goalController,
            startDateController: _startDateController,
            endDateController: _endDateController,
            freqController: _frequencyController,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: FutureBuilder(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text('Someting went wrong'),
                ),
                Container(
                  width: w,
                  height: 40,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserInfoPage(),
                      ),
                    ),
                    child: const Text("Update your profile"),
                  ),
                )
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: backgroundgreen,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: w,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "✅Completed",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.4),
                        height: 30,
                      ),
                      Text(
                        'Current Goals',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('goals')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error fetching data'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('goals')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text('Error fetching data'),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                List<QueryDocumentSnapshot> documents =
                                    snapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: 1,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data = documents[index]
                                        .data() as Map<String, dynamic>;
                                    daysLeft = calculateDaysLeft(
                                      data['start'],
                                      data['deadline'],
                                    );
                                    progress = calculateProgress(
                                      data['start'],
                                      data['deadline'],
                                    );
                                    return goalTile(
                                      context,
                                      data['title'] ?? 'na',
                                      data['freq'] ?? 'na',
                                      data['deadline'] ?? 'na',
                                      progress,
                                      daysLeft,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

String _formatDigits(int digits) {
  return digits < 10 ? '0$digits' : '$digits';
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  String currentDate =
      '${_formatDigits(now.day)}-${_formatDigits(now.month)}-${_formatDigits(now.year)}';
  return currentDate;
}

int calculateDateDifferenceInDays(String today, String deadline) {
  DateTime date1 = DateTime.parse(convertToValidDateFormat(today));
  DateTime date2 = DateTime.parse(convertToValidDateFormat(deadline));

  Duration difference = date2.difference(date1);
  return difference.inDays;
}

String convertToValidDateFormat(String dateString) {
  List<String> parts = dateString.split("-");
  String day = parts[0];
  String month = parts[1];
  String year = parts[2];
  return "$year-$month-$day";
}
