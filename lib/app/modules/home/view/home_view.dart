import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/global/firebase_helper.dart';
import 'package:lets_chat/app/modules/auth/login/view/login_view.dart';
import 'package:lets_chat/app/modules/chat_room/model/chatRoomModel.dart';
import 'package:lets_chat/app/modules/chat_room/view/chat_room.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => search_page_view(
              firebaseUser: firebaseUser,
              userModel: userModel,
            ),
          );
        },
        child: Icon(
          Icons.search,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.until((route) => route.isFirst);
                Get.off(() => login_view());
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
        title: Text(
          'Let\'s Chat',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .where('participants.${userModel.uid}', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatroomsnapshot =
                      snapshot.data as QuerySnapshot;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatroomsnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatroomModel = ChatRoomModel.fromMap(
                            chatroomsnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        Map<String, dynamic> chatParticipants =
                            chatroomModel.participants!;
                        List<String> participantsKeys =
                            chatParticipants.keys.toList();
                        participantsKeys.remove(userModel.uid);

                        return FutureBuilder(
                          future: firebase_helper
                              .getCurrentUserModel(participantsKeys[0]),
                          builder: (context, userData) {
                            if (userData.hasData) {
                              
                              UserModel targetUser = userData.data as UserModel;
                              String username= targetUser.fullName!;
                              username= username[0].toUpperCase()+username.substring(1);
                              return ListTile(
                                onTap: () {
                                  Get.to(
                                    chat_room(
                                      chatRoomModel: chatroomModel,
                                      targetUser: targetUser,
                                      currentusermodel: userModel,
                                      firebaseUser: firebaseUser,
                                    ),
                                  );
                                },
                                title: Text(username),
                                subtitle: chatroomModel.lastmsg == ""
                                    ? Text('Say Hii to your new friend!')
                                    : Text(chatroomModel.lastmsg.toString()),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profilePicUrl.toString()),
                                ),
                              );
                            } else if (userData.hasError) {
                              return Container(
                                height: Get.height,
                                child: Center(
                                  child: Text('An Error has Occured'),
                                ),
                              );
                            } else {
                              return Container(
                                height: Get.height,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('An Error Occured'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
