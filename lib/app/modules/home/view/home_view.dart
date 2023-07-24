import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/home/view/search_page_view.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class Home_view extends StatelessWidget {
  User firebaseUser;
  UserModel userModel;
  Home_view({super.key, required this.firebaseUser, required this.userModel});

  ImageProvider? imageProvider;
  void getImage(String url) {
    imageProvider = NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => search_page_view(
                  firebaseUser:   firebaseUser,
                      userModel: userModel,
                    ));
              },
              icon: Icon(
                Icons.search,
              ))
        ],
        title: Text(
          'Home View',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Image(
              image: NetworkImage(userModel.profilePicUrl.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
