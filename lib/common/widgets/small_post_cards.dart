// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/posts/data/post_data_model.dart';
import 'package:gymapp/features/posts/pages/post_detail_page.dart';

class SmallPostCard extends ConsumerStatefulWidget {
  final PostDataModel postData;

  const SmallPostCard({
    required this.postData,
    super.key,
  });

  @override
  ConsumerState<SmallPostCard> createState() => _SmallPostCardState();
}

class _SmallPostCardState extends ConsumerState<SmallPostCard> {
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
        color: Color.fromARGB(255, 255, 255, 255), // White card
        elevation: 0.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Row(
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
                              fontSize:
                                  14.sp, // Slightly larger font size for time
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 43.h,
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Text(
                  widget.postData.postContent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                child: widget.postData.postImageUrl != null
                    ? Image.network(
                        widget.postData.postImageUrl,
                        width: 400.w,
                        fit: BoxFit.cover,
                        height: 180.h,
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
                          return Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
