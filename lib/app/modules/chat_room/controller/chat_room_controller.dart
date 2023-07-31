import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/Message/message_model.dart';
import 'package:lets_chat/app/modules/chat_room/model/chatRoomModel.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';
import 'package:lets_chat/main.dart';

class chat_room_controller extends GetxController {
  TextEditingController msgcontroller = TextEditingController();

  Future<ChatRoomModel?> getchatRoomModel(
      UserModel targetUsermodel, UserModel currentUsermodel) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${targetUsermodel.uid}', isEqualTo: true)
        .where('participants.${currentUsermodel.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // fetch chat room
      log('chat room already exist so fetch it');

      // hmare paas ek se jyada chat room nhi ho skte do user k liye isliye docs list m ek hi element hoga

      var existingchatroomData = snapshot.docs[0].data();

      ChatRoomModel existingUserModel =
          ChatRoomModel.fromMap(existingchatroomData as Map<String, dynamic>);
      log(existingchatroomData.toString());
      return existingUserModel;
    } else {
      // chat room didnot exist so creating chatroom
      // creating chat room
      log('chat room didnot exist so creating chatroom');

      ChatRoomModel newchatroomModel = ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastmsg: "",
        participants: {
          targetUsermodel.uid.toString(): true,
          currentUsermodel.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newchatroomModel.chatRoomId)
          .set(newchatroomModel.toMap());
      log('new chat room created');
      return newchatroomModel;
    }
  }

  void getandsend(String msg, UserModel currentUsermodel,
      UserModel targetUsermodel, ChatRoomModel chatRoomModel) async {
    if (msg != null) {
      Message_model newMsgModel = Message_model(
        msgId: uuid.v1(),
        seen: false,
        create_msg_time: DateTime.now(),
        text: msg,
        sender: currentUsermodel.uid,
      );
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomModel.chatRoomId.toString())
          .collection('messages')
          .doc(newMsgModel.msgId)
          .set(newMsgModel.toMap());
      chatRoomModel.lastmsg = msg;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomModel.chatRoomId)
          .set(chatRoomModel.toMap());
      log('msg sent!');
      msgcontroller.clear();
    }
  }
}
