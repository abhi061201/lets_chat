import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/Message/message_model.dart';
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
    String username = targetUser.fullName.toString();

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
        leadingWidth: 25,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                targetUser.profilePicUrl.toString(),
              ),
              radius: 20,
            ),
            SizedBox(
              width:8,
            ),
            Container(
              width: Get.width*0.3,
              child: Text(
                username,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(chatRoomModel.chatRoomId)
                  .collection('messages')
                  .orderBy('create_msg_time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      reverse: true,
                      itemCount: datasnapshot.docs.length,
                      itemBuilder: (context, index) {
                        Message_model cur_message = Message_model.fromMap(
                            datasnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Row(
                          mainAxisAlignment:
                              cur_message.sender == currentusermodel.uid
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    cur_message.sender == currentusermodel.uid
                                        ? Colors.teal
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(cur_message.text.toString()),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                } else {
                  return Center(
                    child: Text('Pleas check your internet connection'),
                  );
                }
              },
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 248, 248),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
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
