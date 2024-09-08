// // ignore_for_file: unnecessary_null_comparison

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gymapp/common/functions/date.dart';
// import 'package:gymapp/features/posts/data/post_data_model.dart';
// import 'package:gymapp/features/posts/data/post_data_source.dart';
// import 'package:gymapp/features/posts/pages/edit_post_page.dart';
// import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';
// import 'package:gymapp/features/profile/data/user_service.dart';

// class PostDetailsPage extends ConsumerStatefulWidget {
//   final PostDataModel postData;

//   const PostDetailsPage({super.key, required this.postData});

//   @override
//   ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
// }

// class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
//   final EditDeleteLogic editDeleteLogic = EditDeleteLogic();

//   @override
//   Widget build(BuildContext context) {
//     final userData = ref.watch(userProvider);

//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 230, 240, 255),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 230, 240, 255),
//         iconTheme: IconThemeData(
//           color: Theme.of(context).colorScheme.inversePrimary,
//         ),
//         title: Text(
//           'POST DETAILS',
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.inversePrimary,
//             letterSpacing: 4,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'delete') {
//                 EditDeleteLogic.deletePost(
//                   context,
//                   widget.postData.postId,
//                 );
//                 ref.read(postProvider).whenData((value) {
//                   value.remove(widget.postData);
//                 });
//                 ref.refresh(postProvider);
//               } else if (value == 'edit') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditPostPage(
//                       postDataModel: widget.postData,
//                     ),
//                   ),
//                 );
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//               final postUserId = widget.postData.userId;

//               // Conditional PopupMenuItems
//               List<PopupMenuEntry<String>> menuItems = [];

//               if (currentUserId == postUserId) {
//                 // Show both "Edit" and "Delete" only if current user is the post owner
//                 menuItems.add(
//                   const PopupMenuItem<String>(
//                     value: 'edit',
//                     child: Text('Edit Post'),
//                   ),
//                 );
//                 menuItems.add(
//                   const PopupMenuItem<String>(
//                     value: 'delete',
//                     child: Text('Delete Post'),
//                   ),
//                 );
//               }

//               return menuItems;
//             },
//             icon: Icon(Icons.more_vert, size: 24.sp),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           userData.when(
//                             data: (data) {
//                               return CircleAvatar(
//                                 radius: 20.r,
//                                 backgroundImage:
//                                     NetworkImage(data.profileImageUrl ?? ''),
//                               );
//                             },
//                             error: (error, stackTrace) {
//                               return Text(error.toString());
//                             },
//                             loading: () => const CircularProgressIndicator(),
//                           ),
//                           SizedBox(width: 15.w),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 userData.when(
//                                   data: (data) {
//                                     return Text(
//                                       data.name ?? 'Enter Name',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 22.sp,
//                                       ),
//                                     );
//                                   },
//                                   error: (error, stackTrace) {
//                                     return Text(error.toString());
//                                   },
//                                   loading: () =>
//                                       const CircularProgressIndicator(),
//                                 ),
//                                 Text(
//                                   "Posted in ${timeAgo(DateTime.parse(widget.postData.postCreatedAt))}",
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ClipRRect(
//                     clipBehavior: Clip.antiAlias,
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(10.0),
//                     ),
//                     child: widget.postData.postImageUrl != null
//                         ? Image.network(
//                             widget.postData.postImageUrl,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             height: 350.h,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   value: loadingProgress.expectedTotalBytes !=
//                                           null
//                                       ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes!
//                                       : null,
//                                 ),
//                               );
//                             },
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Text(
//                                 'Error!!!',
//                               );
//                             },
//                           )
//                         : Image.asset(
//                             'assets/no_image.jpg',
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             height: 200.h,
//                           ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.postData.postHeadline,
//                         style: TextStyle(
//                           fontSize: 25.sp,
//                           fontStyle: FontStyle.italic,
//                           color: Theme.of(context).colorScheme.inversePrimary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Date: ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             TextSpan(
//                               text: formatDateTime(
//                                 widget.postData.postCreatedAt,
//                               ),
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Content: ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextSpan(
//                               text: widget.postData.postContent,
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Exercises: ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextSpan(
//                               text: widget.postData.exercises.join(", "),
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Achievements: ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextSpan(
//                               text: widget.postData.achievements.join(", "),
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Fitness Goals: ',
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             TextSpan(
//                               text: widget.postData.fitnessGoals.join(", "),
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inversePrimary,
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/edit_post_page.dart';
import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';
import 'package:gymapp/features/profile/data/user_service.dart';

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
    // Fetch the user data of the post's author using the userId in the post
    final postAuthorData = ref.watch(userByIdProvider(widget.postData.userId));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 240, 255),
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
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              final postUserId = widget.postData.userId;

              // Conditional PopupMenuItems
              List<PopupMenuEntry<String>> menuItems = [];

              if (currentUserId == postUserId) {
                // Show both "Edit" and "Delete" only if current user is the post owner
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit Post'),
                  ),
                );
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete Post'),
                  ),
                );
              }

              return menuItems;
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
                // Display the post author's profile information
                postAuthorData.when(
                  data: (userData) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage:
                                NetworkImage(userData.profileImageUrl ?? ''),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name ?? 'Enter Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
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
                    );
                  },
                  error: (error, stackTrace) {
                    return Text(error.toString());
                  },
                  loading: () => const CircularProgressIndicator(),
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
                              return const Text('Error!!!');
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
