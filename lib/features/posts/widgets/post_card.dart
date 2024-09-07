// // ignore_for_file: unnecessary_null_comparison

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gymapp/common/functions/date.dart';
// import 'package:gymapp/features/posts/data/post_data_model.dart';
// import 'package:gymapp/features/posts/data/post_data_source.dart';
// import 'package:gymapp/features/posts/pages/post_detail_page.dart';
// import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';

// class PostCard extends ConsumerStatefulWidget {
//   final PostDataModel postData;

//   const PostCard({
//     required this.postData,
//     super.key,
//   });

//   @override
//   ConsumerState<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends ConsumerState<PostCard> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => PostDetailsPage(
//               postData: widget.postData,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 0,
//         margin: EdgeInsets.all(12.sp),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 28.r,
//                       ),
//                       SizedBox(width: 15.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.postData.postHeadline,
//                               style: TextStyle(
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "Posted in ${timeAgo(DateTime.parse(widget.postData.postCreatedAt))}",
//                               style: TextStyle(
//                                 fontSize:
//                                     14.sp, // Slightly larger font size for time
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.w),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.postData.postHeadline,
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 widget.postData.postContent,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 15.sp,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 0.w),
//                         child: IconButton(
//                           onPressed: () {
//                             EditDeleteLogic.deletePost(
//                               context,
//                               widget.postData.postId,
//                             );
//                             ref.read(postProvider).whenData((value) {
//                               value.remove(widget.postData);
//                             });
//                             ref.refresh(postProvider);
//                           },
//                           icon: Icon(
//                             Icons.delete,
//                             size: 23.sp,
//                             color: Colors.red.shade300,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(12.0)),
//               child: widget.postData.postImageUrl != null
//                   ? Image.network(
//                       widget.postData.postImageUrl!,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       height: 200.h,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/no_image.jpg',
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           height: 200.h,
//                         );
//                       },
//                     )
//                   : Image.asset(
//                       'assets/no_image.jpg',
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       height: 200.h,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/post_detail_page.dart';
import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostDataModel postData;

  const PostCard({
    required this.postData,
    super.key,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostDetailsPage(
              postData: widget.postData,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete Post'),
                            ),
                          ];
                        },
                        icon: Icon(Icons.more_vert, size: 24.sp),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postData.postHeadline,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.postData.postContent,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: widget.postData.postImageUrl != null
                  ? Image.network(
                      widget.postData.postImageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 200.h,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/no_image.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: 200.h,
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
          ],
        ),
      ),
    );
  }
}
