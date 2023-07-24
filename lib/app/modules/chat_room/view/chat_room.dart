import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/chat_room/controller/chat_room_controller.dart';
import 'package:lets_chat/app/modules/chat_room/model/chatRoomModel.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class chat_room extends StatelessWidget {
  final UserModel currentusermodel;
  final User firebaseUser;
  ChatRoomModel chatRoomModel;
  UserModel targetUser;

  chat_room({
    super.key,
    required this.currentusermodel,
    required this.chatRoomModel,
    required this.firebaseUser,
    required this.targetUser,
  });
  chat_room_controller controller = Get.put(chat_room_controller());
  @override
  Widget build(BuildContext context) {
    String username = currentusermodel.fullName.toString();

    username = username[0].toString().toUpperCase() + username.substring(1);
    print(username.toString());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            // constraints: BoxConstraints(),
            onPressed: () {},
            icon: Icon(
              Icons.video_call,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(
              Icons.call,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
            ),
          ),
        ],
        leadingWidth: 20,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                currentusermodel.profilePicUrl.toString(),
              ),
              radius: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text(username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 248, 248),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: controller.msgcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      hintText: 'Enter the message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.getandsend(
                      controller.msgcontroller.text.trim().toString(),
                      currentusermodel,
                      targetUser,
                      chatRoomModel,
                    );
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
