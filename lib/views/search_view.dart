import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intagramclone/controllers/my_search_page_controller.dart';
import 'package:intagramclone/model/user_model.dart';
import 'package:get/get.dart';
import 'package:intagramclone/pages/HomePage/user_profel_page.dart';
Widget itemOdUserSearch(MySearchController controller,context,User user) {
  return Container(
    //color: Colors.yellow,
    //height: 150,
    padding: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      shape: const RoundedRectangleBorder(),

      focusColor: Colors.blue,
      // minLeadingWidth: 0,
      leading: InkWell(
        onTap: () {
          Get.to(UserProfilePage(),arguments: user.uid!);
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => UserProfilePage(
          //       userUid: user.uid!,
          //     )));
        },
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.deepPurple,
          child: user.imageUrl == null
              ? const CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage("assets/images/user_image.png"),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageUrl: user.imageUrl!,
              placeholder: (context, url) => const Image(
                  image: AssetImage("assets/images/user_image.png")),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      title: Text(user.fullName),
      subtitle: Text(
        user.email,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: MaterialButton(
        onPressed: () => controller.updateFollow(user),
        height: 30,
        color: user.followed ? Colors.blue : Colors.white60,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.58),
            side: const BorderSide(color: Colors.grey, width: 1)),
        child: Text(
          user.followed ? "Following" : "Follow",
          style: TextStyle(
              color: user.followed ? Colors.white : Colors.grey,
              fontSize: 16),
        ),
      ),
    ),
  );
}