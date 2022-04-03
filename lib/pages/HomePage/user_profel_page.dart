import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/user_profile_page_controller.dart';

class UserProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
        init: UserProfileController(),
        builder: (_controller) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              centerTitle: true,
              title: const Text(
                "Profile",
                style: TextStyle(
                    color: Colors.black, fontSize: 25, fontFamily: "Billabong"),
              ),
            ),
            body: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    scrollDirection: Axis.vertical, cacheExtent: 1.0,
                    physics: const BouncingScrollPhysics(),
                    //shrinkWrap: true,
                    slivers: [
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate //SliverChildBuilderDelegate
                                  (
                        (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                radius: 44,
                                backgroundColor: Colors.deepPurple,
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundColor: Colors.white,
                                  child: _controller.user?.imageUrl == null ||
                                          _controller.user!.imageUrl!.isEmpty
                                      ? const CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              "assets/images/user_image.png"),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image(
                                            image: NetworkImage(
                                                _controller.user!.imageUrl!),
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _controller.user == null
                                    ? ""
                                    : _controller.user!.fullName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _controller.user == null
                                    ? ""
                                    : _controller.user!.email,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  UsersInfo(
                                      text: "POSTS",
                                      count: _controller.countPosts.toString()),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                  UsersInfo(
                                      text: "Following",
                                      count: _controller.user == null
                                          ? "0"
                                          : _controller.user!.following_count
                                              .toString()),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                  UsersInfo(
                                      text: "Followers",
                                      count: _controller.user == null
                                          ? "0"
                                          : _controller.user!.followers_count
                                              .toString()),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                        childCount: 1, // 1000 list items
                      )),
                      SliverAppBar(
                        elevation: 0,
                        expandedHeight: 0,
                        toolbarHeight: 0,
                        pinned: true,
                        forceElevated: true,
                        bottom: AppBar(
                          titleSpacing: 0,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          flexibleSpace: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _controller.cout = 1;
                                  },
                                  icon: const Icon(
                                    Icons.event_note_outlined,
                                    size: 25,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _controller.cout = 2;
                                  },
                                  icon: const Icon(
                                    Icons.apps_sharp,
                                    size: 25,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (_controller.items.length == 0) {
                                return const Center(
                                  child: const Text("You don't have post"),
                                );
                              }
                              return InkWell(
                                  onLongPress: () {},
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageUrl: _controller
                                              .items[index].postImage,
                                          placeholder: (context, text) =>
                                              Container(
                                            height: 50,
                                            width: double.infinity,
                                            color: Colors.grey,
                                          ),
                                          errorWidget: (context, text, _) =>
                                              const Center(
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(_controller.items[index].caption)
                                    ],
                                  ));
                            },
                            childCount:
                                _controller.items.length, // 1000 list items
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _controller.cout == 1 ? 1 : 2,
                                  mainAxisSpacing:
                                      _controller.cout == 2 ? 5.0 : 0.0,
                                  crossAxisSpacing: 5))
                    ],
                  ),
          );
        });
  }

  Column UsersInfo({
    required String text,
    required String count,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}
