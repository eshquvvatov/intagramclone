import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/home_page_controller.dart';
import 'package:intagramclone/pages/HomePage/my_feed_page.dart';
import 'package:intagramclone/pages/HomePage/my_likes_page.dart';
import 'package:intagramclone/pages/HomePage/my_profile_page.dart';
import 'package:intagramclone/pages/HomePage/my_search_page.dart';
import 'package:intagramclone/pages/HomePage/my_upload_Page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
static const id="/home_page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 //late PageController _pageController ;



  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   if(mounted){
  //     super.setState(fn);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
   return  GetBuilder<HomePageController>(
       init: HomePageController(),
    builder: (_controller) {
      return Scaffold(
        body: PageView(
          controller: _controller.pageController,
          onPageChanged: (index){
            _controller.currentIndex=index;
            _controller.update();

          },
          /// #pageveiw_children
          children: [
            MyFeedPage(pageController: _controller.pageController,),
            const MySearchPage(),
            MyUploadPage(pageController: _controller.pageController,),
            const MyLikesPage(),
            MyProfilePage(pageController: _controller.pageController,)
          ],
        ),
        /// #bottomNavigation
        bottomNavigationBar:CupertinoTabBar(
          currentIndex: _controller.currentIndex,
          inactiveColor: Colors.grey,
          activeColor: Colors.transparent,
          onTap: (index){
            _controller.currentIndex=index;
            _controller.update();
            _controller.pageController.jumpToPage(_controller.currentIndex);
            _controller.update();
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,size: 32,color:_controller.currentIndex==0?const Color.fromRGBO(193, 53, 132, 1):Colors.grey ,),),
            BottomNavigationBarItem(icon: Icon(Icons.search,size: 32,color:_controller.currentIndex==1?const Color.fromRGBO(193, 53, 132, 1):Colors.grey ,),),
            BottomNavigationBarItem(icon: Icon(Icons.add_box,size: 32,color:_controller.currentIndex==2?const Color.fromRGBO(193, 53, 132, 1):Colors.grey ,),),
            BottomNavigationBarItem(icon: Icon(Icons.favorite,size: 32,color:_controller.currentIndex==3?const Color.fromRGBO(193, 53, 132, 1):Colors.grey ),),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle,size: 32,color:_controller.currentIndex==4?const Color.fromRGBO(193, 53, 132, 1):Colors.grey ),),
          ],) ,
      );
    });

  }
}
