import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/my_search_page_controller.dart';
import 'package:intagramclone/views/search_view.dart';

class MySearchPage extends StatelessWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: "Billabong"),
        ),
      ),
      body: GetBuilder<MySearchController>(
          init: MySearchController(),
          builder: (_controller) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: _controller.controller,
                          onChanged: (keyword) {
                            _controller.apiSearchUsers(keyword);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.grey.shade700,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(left: 10, top: 0),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                              filled: true,
                              hintText: "Search",

                              /// enabled bosilmagandagi ko'rinish
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(7.5)),

                              /// bosilgandagi border
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(7.5))),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: _controller.user.length,
                        itemBuilder: (context, index) {
                          return itemOdUserSearch(
                              _controller, context, _controller.user[index]);
                        },
                      ))
                    ],
                  ),
                ),
                if (_controller.isLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            );
          }),
    );
  }
}
