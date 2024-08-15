import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/my_button.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/widgets/my_post_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _postService = PostDataSource();

  late String postImageUrl;
  File? image;
  UploadTask? uploadTask;

  final TextEditingController postHeadlineController = TextEditingController();
  final TextEditingController postContentController = TextEditingController();
  final TextEditingController exercisesController = TextEditingController();
  final TextEditingController achievementsController = TextEditingController();
  final TextEditingController fitnessGoalsController = TextEditingController();

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // Send the notification...
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle notification when app is in foreground
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when app is opened from a terminated state
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String result = await _postService.createPost(
        postHeadline: postHeadlineController.text.trim(),
        postContent: postContentController.text.trim(),
        // postImageUrl: postImageUrl,
        exercises: exercisesController.text
            .trim()
            .split(','), // Assuming comma-separated values
        achievements: achievementsController.text.trim().split(','),
        fitnessGoals: fitnessGoalsController.text.trim().split(','),
      );
      ref.refresh(postProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post Created')),
      );

      // final ref = FirebaseStorage.instance.ref().child("images/${image!.path}");

      // uploadTask = ref.putFile(image!);

      // final snapshot = await uploadTask!.whenComplete(() => null);

      // final downloadUrl = await snapshot.ref.getDownloadURL();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: const Text(
          'CREATE POST',
          style: TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: postHeadlineController,
                  labelText: 'Headline',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 5,
                  controller: postContentController,
                  labelText: 'Content',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: exercisesController,
                  labelText: 'Exercises',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: achievementsController,
                  labelText: 'Achievements',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: fitnessGoalsController,
                  labelText: 'Fitness Goals',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () async {
                        final picture = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (picture != null) {
                          final imageId = DateTime.now().toString();

                          image = File(picture.path);
                          setState(() {});
                        }
                      },
                      child: image == null
                          ? const CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(
                              image!,
                              height: 350.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                ),
                SizedBox(height: 10.h),
                MyButton(
                  text: 'Post',
                  onTap: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
