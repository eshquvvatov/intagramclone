import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/my_like_page_controller.dart';
import 'package:intagramclone/views/mt_like_view.dart';

class MyLikesPage extends StatelessWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Likes",
            style: TextStyle(
                color: Colors.black, fontSize: 45, fontFamily: "Billabong"),
          ),
        ),
        body: GetBuilder<MyLikePageController>(
            init: MyLikePageController(),
            builder: (_controller) {
              return Stack(
                children: [
                  ListView.builder(
                      itemCount: _controller.items.length,
                      itemBuilder: (context, index) {
                        if (_controller.items.isNotEmpty) {
                          return iteamOfPostLike(
                              _controller, _controller.items[index]);
                        } else {
                          return const Center(
                            child: Text("Your  don't have like post"),
                          );
                        }
                      }),
                  if (_controller.isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                ],
              );
            }));
  }
}
