import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/features/dashboard/home_page.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/edit_post_page.dart';
import 'package:gymapp/features/posts/pages/post_page.dart';
import 'package:gymapp/shared/helper.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';

class EditDeleteLogic {
  static void editPost(
    BuildContext context, {
    required final PostDataModel postDataModel,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostPage(
          postDataModel: postDataModel,
        ),
      ),
    );
  }

  static void deletePost(BuildContext context, String postId) async {
    try {
      // Delete the post from Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      // ignore: use_build_context_synchronously

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post Deleted')),
      );
    } catch (error) {
      // Handle any errors that may occur during the deletion
      if (kDebugMode) {
        print('Error deleting post: $error');
      }
      // Optionally, show a snackbar or alert the user about the error
    }
  }
}
