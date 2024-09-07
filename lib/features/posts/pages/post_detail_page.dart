// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/edit_post_page.dart';
import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  final PostDataModel postData;

  const PostDetailsPage({super.key, required this.postData});

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
  final EditDeleteLogic editDeleteLogic = EditDeleteLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(
          'POST DETAILS',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                EditDeleteLogic.deletePost(
                  context,
                  widget.postData.postId,
                );
                ref.read(postProvider).whenData((value) {
                  value.remove(widget.postData);
                });
                ref.refresh(postProvider);
              } else if (value == 'edit') {
                // Implement your edit logic here
                // For example, you might navigate to an edit page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPostPage(
                      postDataModel: widget.postData,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete Post'),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit Post'),
                ),
              ];
            },
            icon: Icon(Icons.more_vert, size: 24.sp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.postData.postHeadline,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Posted in ${timeAgo(DateTime.parse(widget.postData.postCreatedAt))}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: widget.postData.postImageUrl != null
                        ? Image.network(
                            widget.postData.postImageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 350.h,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'Error!!!',
                              );
                            },
                          )
                        : Image.asset(
                            'assets/no_image.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 200.h,
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postData.postHeadline,
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Date: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: formatDateTime(
                                widget.postData.postCreatedAt,
                              ),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Content: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: widget.postData.postContent,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Exercises: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: widget.postData.exercises.join(", "),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Achievements: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: widget.postData.achievements.join(", "),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Fitness Goals: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: widget.postData.fitnessGoals.join(", "),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
