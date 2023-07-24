import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/chat_room/controller/chat_room_controller.dart';
import 'package:lets_chat/app/modules/chat_room/model/chatRoomModel.dart';
import 'package:lets_chat/app/modules/chat_room/view/chat_room.dart';
import 'package:lets_chat/app/modules/home/controller/search_controller.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class search_page_view extends StatefulWidget {
  search_page_view({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });
  final UserModel userModel;

  final User firebaseUser;

  @override
  State<search_page_view> createState() => _search_page_viewState();
}

class _search_page_viewState extends State<search_page_view> {
  search_controller controller = Get.put(search_controller());
  chat_room_controller chatcontroller = Get.put(chat_room_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search the User',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.02,
          ),
          TextFormField(
            controller: controller.textcontroller,
            decoration: InputDecoration(
              hintText: 'Enter name',
              prefixIcon: Icon(
                Icons.search,
              ),
            ),
          ).paddingSymmetric(
            horizontal: 10,
          ),
          SizedBox(
            height: Get.height * 0.025,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(
              'Search',
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where('email',
                    isEqualTo: controller.textcontroller.text.trim())
                .where('email', isNotEqualTo: widget.userModel.email.toString())
                .snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

                  if (datasnapshot.docs.length > 0) {
                    Map<String, dynamic> userdatamap =
                        datasnapshot.docs[0].data() as Map<String, dynamic>;
                    print(snapshot.toString());
                    UserModel searchedUser = UserModel.fromMap(
                      userdatamap,
                    );
                    return ListTile(
                      onTap: () async {
                        ChatRoomModel? chatRoomModel = await chatcontroller
                            .getchatRoomModel(searchedUser, widget.userModel);
                        if (chatRoomModel != null) {
                          Get.back();
                          Get.to(chat_room(
                            targetUser: searchedUser,
                            currentusermodel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                            chatRoomModel: chatRoomModel,
                          ));
                        }
                      },
                      title: Text(searchedUser.fullName!),
                      subtitle: Text(searchedUser.email.toString()),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          searchedUser.profilePicUrl!,
                        ),
                      ),
                    );
                  } else {
                    return Text('No user Found');
                  }
                } else if (snapshot.hasError) {
                  Text('An error has occured');
                } else {
                  CircularProgressIndicator();
                }
                return Text('No data found');
              }
              return Text('No data found');
            },
          ),
        ],
      ),
    );
  }
}
