import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/features/auth/pages/login_page.dart';
import 'package:gymapp/features/profile/data/user_service.dart';
import 'package:gymapp/features/profile/widgets/my_card_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? _profileImage;
  String? _profileImageUrl;
  String? _userName;

  Future<String> userSignout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _profileImage = imageFile;
      });
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images/$userId/${DateTime.now().toString()}");

    try {
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });
    } catch (e) {
      // Handle errors
      print("Error uploading image: $e");
    }
  }

  Future<void> _updateUserName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(nameController.text);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': newName,
        });
        setState(() {
          _userName = newName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 240, 255),
        title: Text(
          'PROFILE',
          style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              letterSpacing: 4),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_picture') {
                _pickImage();
              } else if (value == 'change_name') {
                _updateUserName();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'change_picture',
                  child: Text('Change Profile Picture'),
                ),
                const PopupMenuItem<String>(
                  value: 'change_name',
                  child: Text('Change Name'),
                ),
              ];
            },
            icon: Icon(Icons.more_vert, size: 24.sp),
          ),
        ],
      ),
      body: userDataAsyncValue.when(
        data: (userData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _profileImage == null
                        ? CircleAvatar(
                            maxRadius: 65,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage("assets/6195145.jpg"),
                          )
                        : CircleAvatar(
                            maxRadius: 65,
                            backgroundImage: FileImage(_profileImage!),
                          ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(height: 10.h),
                Text(
                  userData.name ?? 'No name provided',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/download.png"),
                    ),
                    SizedBox(width: 15),
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/GooglePlus-logo-red.png"),
                    ),
                    SizedBox(width: 15),
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/1_Twitter-new-icon-mobile-app.jpg"),
                    ),
                    SizedBox(width: 15),
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/600px-LinkedIn_logo_initials.png"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DonationHistoryPage(),
                          //   ),
                          // );
                        },
                        title: 'Payment History',
                        leading: const Icon(
                          Icons.history_edu,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () {
                          Share.share('https://gymapp.com');
                        },
                        title: 'Invite a Friend',
                        leading: const Icon(
                          Icons.add_reaction_sharp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      MyCardProfile(
                        onPressed: () async {
                          String result = await userSignout();
                          if (result == "Success") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          } else {
                            if (kDebugMode) {
                              print('Logout Failed');
                            }
                          }
                        },
                        title: 'Logout',
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
