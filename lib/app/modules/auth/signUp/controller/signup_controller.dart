
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class signup_controller extends GetxController {
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  void getvalues_and_check() {
    String email_value = email_controller.text.trim();
    String password_value = password_controller.text.trim();
    String cpassword_value = confirm_password_controller.text.trim();

    if (email_value == "" || password_value == "" || cpassword_value == "") {
      print('fields can\'t be empty');
    } else if (password_value != cpassword_value)
      print('assword and confirm password should be same');
    else {
      signUp(email_value, password_value);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? _credential;
    try {
      _credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.toString());
    }

    if (_credential != null) {
      String uid = _credential!.user!.uid;
      UserModel userObject = UserModel(
        email: email,
        fullName: "",
        uid: uid,
        profilePicUrl: "",
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set(userObject.tomap())
          .then(
            (value) => print(
              'New User Created',
            ),
          );
    }
  }
}
