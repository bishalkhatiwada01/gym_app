import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/edit_post_page.dart';
import 'package:gymapp/features/posts/pages/post_detail_page.dart';
import 'package:gymapp/features/posts/widgets/edit_delete_logic.dart';
import 'package:gymapp/features/profile/data/user_service.dart';

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
    final userData = ref.watch(userProvider);

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
                      userData.when(
                        data: (data) {
                          return CircleAvatar(
                            radius: 20.r,
                            backgroundImage:
                                NetworkImage(data.profileImageUrl ?? ''),
                          );
                        },
                        error: (error, stackTrace) {
                          return Text(error.toString());
                        },
                        loading: () => const CircularProgressIndicator(),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userData.when(
                              data: (data) {
                                return Text(
                                  data.name ?? 'Enter Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                );
                              },
                              error: (error, stackTrace) {
                                return Text(error.toString());
                              },
                              loading: () => const CircularProgressIndicator(),
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
                          final currentUserId =
                              FirebaseAuth.instance.currentUser?.uid;
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
