import 'package:get/get.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/service/data_service.dart';

class MyLikePageController extends GetxController{
  List<Post> items = [];
  bool isLoading = false;

  Future<void> apiLoadLikes() async {
    isLoading = true;
    update();
    DataService.loadLikes().then((value) => {setData(value)});
  }

  setData(response) {
    items = response;
    isLoading = false;
    update();
  }
  void unlikePost(Post post)async{

    isLoading = true;
    update();
    await  DataService.likePost(post, false);
    apiLoadLikes();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiLoadLikes();
  }

}