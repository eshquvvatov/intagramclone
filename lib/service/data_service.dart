import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/model/user_model.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intagramclone/service/utils.dart';

import 'http_service.dart';
class DataService {
  /// init
  static final instance = FirebaseFirestore.instance;

  /// folder
  static const userFolder = "users";
  static const postFolder="posts";
  static const feedFolder="feeds";
  static const followingFolder="following";
  static const followersFolder="followers";
// User
  /// User malumtlarni firebase dagi databasega saqlaydigan function
  static Future storeUser(User user) async {
    user.uid = (await Prefs.load(StorageKeys.UID))!;
    Map<String, String> params = await Utils.deviceParams();
    user.device_id = params["device_id"]!;
    user.device_type = params["device_type"]!;
    user.device_token = params["device_token"]!;
    /// quyidagi kod bizga firebase malmotlarni joylashtirish uchun yordam beradi
    /// firebasedan collection yaratamiz yani malumotlar to'plami va bu to'plam nomi (userFolder = "users") va u doc formatda bo'ladi va harbir doc uid nomi bilan bo'ladi va uning ichiga malumotlarni json farmatda saqlaymiz
    return instance.collection(userFolder).doc(user.uid).set(user.toJson());
  }

  /// firebase database dagi malumotlarni olib beradigan function
  static Future<User> loadUser( String? uid) async {
    /// biz user ni create qilganimizda autheration uzerga maxsus id berardi va biz uni lokal xotiraga saqlaganmiz
    /// shu id ni olib User modeldagi uid fieldga beramiz
    uid ??= (await Prefs.load(StorageKeys.UID));


    /// uid buyicha malumotlarni databasedan json olamiz
     DocumentSnapshot<Map<String, dynamic>> value = await instance.collection("users").doc(uid).get();

    User user = User.fromJson(value.data()!);
    var querySnapshot1 = await instance.collection(userFolder).doc(uid).collection(followersFolder).get();
    user.followers_count = querySnapshot1.docs.length;

    var querySnapshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();
    user.following_count = querySnapshot2.docs.length;

    /// json formatdan objectga o'tkazamiz va qaytarib yuboramiz
    return user;
  }

  /// User malumitlarini yangilaydigan function
  static Future<void> updateUser(User user) async {
    /// bizga uid shart emas chunke biz update qilishdan oldin uni databasega quygan bulamiz va uid ni modelga berganmiz va uid ning qiymati modelimizda mavjud
    // String uid = (await Prefs.load(StorageKeys.UID))!;
    /// update qilganimzda oldingi malumotlarni hammasi o'chirilib yangisiga almashtiriladi
    return instance.collection(userFolder).doc(user.uid).update(user.toJson());
  }

  static Future<List<User>> searchUser(String keyword) async{
   String uid = (await Prefs.load(StorageKeys.UID))!;
    List<User> users =[];
    // write request (query)
    var querySnapshot = await instance.collection(userFolder).orderBy("fullName").startAt([keyword]).endAt([keyword+'\uf8ff']).get();

    if (kDebugMode) {
      print(querySnapshot.docs.toString());
    }
    for (var element in querySnapshot.docs) {
      User newUser = User.fromJson(element.data());
      if (newUser.uid != uid) {
        users.add(newUser);
      }
    }


    List<User> following = [];
    var querySnapshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();

    for (var result in querySnapshot2.docs) {
      following.add(User.fromJson(result.data()));
    }

    for(User user in users){
      if(following.contains(user)){
        user.followed = true;
      }else{
        user.followed = false;
      }
    }
    return users;
  }

  // Post

  /// Postni data base ga saqlaydigan function
 static Future<Post>storePost(Post post)async{
    ///  malumotlarimni me objectiga yuklab olamiz maqsad object malumotlaridan foydalanish
    User me= await loadUser(null);
    /// post uid sin user uid si birxil buladi.Bu bizga post kim tomonidan chiqarilganligini aniqlashda yordam beradi va uid unit bo'ladi
    post.uid=me.uid!;

    post.fullName = me.fullName;
    post.imageUser = me.imageUrl;
    post.createdDate = DateTime.now().toString();
    /// Bunda biz malumot saqlaydigan joy manzili va joy nomini olib kelamiz va uni post.id ga beramiz
    /// keyin shu id manziliga post malumotlarini joy laylaymiz
    String postId = instance.collection(userFolder).doc(me.uid).collection(postFolder).doc().id;
    post.id = postId;
    await instance.collection(userFolder).doc(me.uid).collection(postFolder).doc(postId).set(post.toJson());
    return post;
 }
  static Future<Post> storeFeed(Post post) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).set(post.toJson());
    return post;
  }

  /// database dagi feed malumotlarni olib beradigan function
  static Future<List<Post>> loadFeeds() async {
    /// posts listi bizga postlar ni yig'ib beradi
    List<Post> posts = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    /// querySnapshot bu biz firebase data dan biz suragan malumotlar buyicha datani beradi
    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(feedFolder).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if(post.uid == uid) {post.isMine = true;}
      posts.add(post);
    }

    return posts;
  }
  static Future<List<Post>> loadPosts(String? uid) async {
    List<Post> posts = [];
     uid ??= (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(postFolder).get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }
  static Future<Post> likePost(Post post, bool liked) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    post.isLiked = liked;

    await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).update(post.toJson());

    if(uid == post.uid) {
      await instance.collection(userFolder).doc(uid).collection(postFolder).doc(post.id).update(post.toJson());
    }

    return post;
  }

  static Future<List<Post>> loadLikes() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(uid).collection(feedFolder).where("isLiked", isEqualTo: true).get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if(post.uid == uid) post.isMine = true;
      posts.add(post);
    }

    return posts;
  }

  // Follower and Followings

 static Future<User>followUser(User someone)async{
    User me = await loadUser(null);
print("follo bosildi");
    await HttpService.POST(HttpService.API_SEND, HttpService.paramCreate(someone.device_token, me.fullName, someone.fullName)).then((value) => print(value));
    /// I followed to someone
   await instance.collection(userFolder).doc(me.uid).collection(followingFolder).doc(someone.uid).set(someone.toJson());
   // I am in someone's followers
   await instance.collection(userFolder).doc(someone.uid).collection(followersFolder).doc( me.uid).set(me.toJson());
return someone;
 }

 static Future<User>unFollowUser(User someone)async{
    User me = await loadUser(null);
    // I unfollow to someone
   await instance.collection(userFolder).doc(me.uid).collection(followingFolder).doc(someone.uid).delete();
    // I am not in someone`s followers
    await instance.collection(userFolder).doc(someone.uid).collection(followersFolder).doc(me.uid).delete();
    return someone;
 }
  static Future storePostsToMyFeed(User someone) async {
    // Store someone`s posts to my feed
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(someone.uid).collection(postFolder).get();

   // Post post = Post.fromJson(querySnapshot.docs.first.data());

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      post.isLiked = false;
      posts.add(post);
    }
    for(Post post in posts) {
      storeFeed(post);
    }

  }
  static Future removePostsFromMyFeed(User someone) async {
    // Remove someone`s posts from my feed
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(someone.uid).collection(postFolder).get();
    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    for(Post post in posts){
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;

    return await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).delete();
  }

  static Future removePost(Post post) async {
    await removeFeed(post);
    return await instance.collection(userFolder).doc(post.uid).collection(postFolder).doc(post.id).delete();
  }
}
