// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymapp/common/widgets/my_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/posts/data/post_data_source.dart';
import 'package:gymapp/features/posts/pages/create_post_page.dart';
import 'package:gymapp/features/posts/widgets/post_card.dart';
import 'package:gymapp/features/profile/data/user_service.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({
    super.key,
  });

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  @override
  Widget build(BuildContext context) {
    final postData = ref.watch(postProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 240, 255),
        title: const Text("POSTS"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: postData.when(
        data: (data) {
          return data.isEmpty
              ? Center(
                  child: Text(
                  'No Posts',
                  style: TextStyle(fontSize: 20.sp),
                ))
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(postProvider);
                    ref.refresh(userProvider);
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return PostCard(
                        postData: data[index],
                      );
                    },
                    itemCount: data.length,
                  ),
                );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostPage(),
              ));
        },
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Icon(
          Icons.add,
          size: 20.w,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
