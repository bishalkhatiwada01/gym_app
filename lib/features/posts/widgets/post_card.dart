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
    // final donationData = ref.watch(donationServiceProvider);
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
        elevation: 4.0,
        margin: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDateTime(
                          widget.postData.postCreatedAt,
                        ),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: Text(
                          timeAgo(
                              DateTime.parse(widget.postData.postCreatedAt)),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          EditDeleteLogic.deletePost(
                            context,
                            widget.postData.postId,
                          );
                          ref.read(postProvider).whenData((value) {
                            value.remove(widget.postData);
                          });
                          ref.refresh(postProvider);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 23.sp,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
