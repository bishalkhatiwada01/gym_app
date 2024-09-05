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
        elevation: 4.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ClipRRect(
              //   borderRadius:
              //       const BorderRadius.vertical(top: Radius.circular(12.0)),
              //   child: Image.network(
              //     widget.postData.postImageUrl!,
              //     height: 108.sp,
              //     width: double.infinity,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: widget.postData.postImageUrl != null
                    ? Image.network(
                        widget.postData.postImageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 140.h,
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
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Text(
                  widget.postData.postHeadline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Text(
                  timeAgo(DateTime.parse(widget.postData.postCreatedAt)),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
