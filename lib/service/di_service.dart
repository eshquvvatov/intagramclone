import 'package:get/get.dart';
import 'package:intagramclone/controllers/sign_in_controller.dart';

import '../controllers/home_page_controller.dart';
import '../controllers/my_feed_page_controller.dart';
import '../controllers/my_like_page_controller.dart';
import '../controllers/my_profile_page_controller.dart';
import '../controllers/my_search_page_controller.dart';
import '../controllers/my_upload_page_controller.dart';
import '../controllers/sign_up_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/user_profile_page_controller.dart';


class DIService {
  static Future<void> init() async {
    Get.lazyPut<SignInPageController>(() => (SignInPageController()), fenix: true);
    Get.lazyPut<HomePageController>(() => (HomePageController()), fenix: true);
    Get.lazyPut<SplashController>(() => (SplashController()), fenix: true);
    Get.lazyPut<SignUpPageController>(() => (SignUpPageController()), fenix: true);
    Get.lazyPut<UserProfileController>(() => (UserProfileController()), fenix: true);
    Get.lazyPut<MyUpLoadController>(() => (MyUpLoadController()), fenix: true);
    Get.lazyPut<MySearchController>(() => (MySearchController()), fenix: true);
    Get.lazyPut<MyProfileController>(() => (MyProfileController()), fenix: true);
    Get.lazyPut<MyLikePageController>(() => (MyLikePageController()), fenix: true);
    Get.lazyPut<MyFeedController>(() => (MyFeedController()), fenix: true);
    // Get.lazyPut<MainController>(() => MainController(), fenix: true);
    // Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    // Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
  }
}