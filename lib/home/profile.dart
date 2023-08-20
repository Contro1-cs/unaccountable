import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unaccountable/landing_page.dart';
import 'package:unaccountable/user_onboarding/user_info.dart';
import 'package:unaccountable/widgets/custom_snackbars.dart';
import 'package:unaccountable/widgets/textfields.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController(text: 'Abcd');
  TextEditingController age = TextEditingController(text: '21');
  File? image;
  late String imageUrl;
  bool noImage = false;
  bool pfpLoading = true;
  final storageRef = FirebaseStorage.instance.ref();

  bool isLoading = true;

  Future<void> refreshProfile() async {
    // Reset the image and image URL
    setState(() {
      image = null;
      imageUrl = '';
      noImage = false;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;

    // Get updated data from Firestore
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          name.text = data['name'];
          age.text = data['age'];
        });
      } else {
        // If the document does not exist, show an error message
        setState(() {
          name.text = '';
          age.text = '';
        });
        errorSnackbar(context, 'User data not found');
      }
    } catch (e) {
      errorSnackbar(context, 'Failed to fetch user data: ${e.toString()}');
    }

    // Get updated image URL from Firebase Storage
    try {
      final FirebaseStorage storageRef = FirebaseStorage.instance;
      var ref = storageRef.ref().child(uid).child("$uid.png");
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
        noImage = false;
      });
    } catch (e) {
      setState(() {
        imageUrl = '';
        noImage = true;
      });
    }
  }

  updateProfile() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final users = FirebaseFirestore.instance.collection('users');

    users.doc(uid).update({
      'name': name.text
          .split(" ")
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(" "),
      'age': age.text,
    });
  }

  Future<void> uploadImageToFirebaseStorage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    String filePath = image!.path;
    File file = File(filePath);

    try {
      setState(() {
        isLoading = true;
      });
      var imageRef = storageRef.child("$uid/$uid.png");
      var uploadTask = imageRef.putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {});
      await uploadTask;
      refreshProfile().then(
          (value) => successSnackbar(context, 'Image uploaded successfully!'));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      errorSnackbar(context, 'Something went wrong: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) errorSnackbar(context, 'Failed to pick image');
      final receipt = File(image!.path);
      setState(() {
        this.image = receipt;
      });
      uploadImageToFirebaseStorage();
    } on PlatformException catch (e) {
      errorSnackbar(context, e.toString());
    }
  }

  Future getImage() async {
    final FirebaseStorage storageRef = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    String uid = user.uid;
    try {
      var ref = storageRef.ref().child(uid).child("$uid.png");
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
        pfpLoading = false;
        noImage = false;
      });
    } catch (e) {
      setState(() {
        imageUrl = '';
        pfpLoading = false;
        noImage = true;
      });
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    getImage();
  }

  @override
  void dispose() {
    super.dispose();
    updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: backgroundgreen,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundgreen,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            name.text = data['name'];
            age.text = data['age'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: noImage
                            ? const Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.black,
                              )
                            : pfpLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ClipOval(
                                    child: Image(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                      ),
                      onTap: () {
                        pickImage();
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileFormField(
                      controller: name,
                      title: 'Name',
                      inputType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    ProfileFormField(
                      controller: age,
                      title: 'Age',
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            height: 130,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  lightGreen,
                                  backgroundgreen,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Streak (days)",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "1255",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(15),
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  lightGreen,
                                  backgroundgreen,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Goals",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "3",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: w,
                      height: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            lightGreen,
                            lightGreen.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: w,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFF5353),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
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
