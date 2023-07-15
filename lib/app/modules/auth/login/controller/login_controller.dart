import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class login_controller extends GetxController {
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  void get_values_and_signup() {
    String email = email_controller.text.trim();
    String password = password_controller.text.trim();
    if(email==""|| password=="")print('Fields could not be empty');
    else signin(email, password);
  }

  void signin(String email, String password) async {
    UserCredential? _credential;
    try {
      _credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString());
    }
    if (_credential != null) {
      String uid = _credential!.user!.uid;
      
      DocumentSnapshot userdata =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
          
      print(userdata.toString());
      
      UserModel userData= UserModel.fromMap(userdata.data() as Map<String,dynamic>);
      print(userData.email);
      print('user signed in successfully');
    }
  }
}
