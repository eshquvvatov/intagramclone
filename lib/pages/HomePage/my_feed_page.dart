import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/my_feed_page_controller.dart';
import 'package:intagramclone/views/my_feed_view.dart';

class MyFeedPage extends StatelessWidget {
  PageController pageController;

  MyFeedPage({required this.pageController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyFeedController>(
        init: MyFeedController(),
        builder: (_controller) {
          return Scaffold(
            /// #AppBar
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Instagram",
                style: TextStyle(
                    color: Colors.black, fontSize: 45, fontFamily: "Billabong"),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      pageController.jumpToPage(2);
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ))
              ],
            ),

            /// #body
            body: Stack(
              children: [
                ListView.builder(
                    itemCount: _controller.items.length,
                    itemBuilder: (context, index) {
                      return iteamOfPostFeed(
                          _controller, context, _controller.items[index]);
                    }),

                /// #progrecIndecator
                if (_controller.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          );
        });
  }
}
