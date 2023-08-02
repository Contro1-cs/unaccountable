import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:unaccountable/home/list_page.dart';
import 'package:unaccountable/home/profile.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/user_onboarding/user_info.dart';
import 'package:unaccountable/widgets/goal_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int currentIndex = 0;

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List list = [
    const HomeBody(),
    const ListPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundgreen,
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        padding: const EdgeInsets.all(15),
        tabMargin: const EdgeInsets.all(10),
        backgroundColor: lightGreen.withOpacity(0.3),
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.white.withOpacity(0.3),
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: 'Home',
          ),
          GButton(
            icon: Icons.list,
            text: 'Goals',
          ),
          GButton(
            icon: Icons.person_outline,
            text: 'Profile',
          ),
        ],
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: list[currentIndex],
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final users = FirebaseFirestore.instance.collection('users');

    int daysLeft;
    double progress;

    String getCurrentDate() {
      String formatDigits(int digits) {
        return digits < 10 ? '0$digits' : '$digits';
      }

      DateTime now = DateTime.now();
      String currentDate =
          '${formatDigits(now.day)}-${formatDigits(now.month)}-${formatDigits(now.year)}';
      return currentDate;
    }

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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              backgroundColor: backgroundgreen,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name box
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xff166B6E),
                            ),
                          ),
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Hey ${data['name'].toString().split(' ').first},',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        //Quote box
                        Container(
                          width: w,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                lightGreen,
                                lightGreen.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "“You will never see a hater doing better than you!”",
                                style: GoogleFonts.carroisGothicSc(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "-David Goggins",
                                  style: GoogleFonts.carroisGothicSc(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        //Stream box
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                'Current Streak',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '51 Days',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Top goal',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 160,
                          width: w,
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
                          ),
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.4),
                        ),
                        Text(
                          'Current goals',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: w,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
