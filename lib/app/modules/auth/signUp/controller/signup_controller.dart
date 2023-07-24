import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/app/modules/auth/signUp/view/completeProfilePage.dart';
import 'package:lets_chat/app/modules/home/view/home_view.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class signup_controller extends GetxController {
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  RxBool signupbutton = false.obs;
  RxBool submitbutton = false.obs;
  void getvalues_and_check() {
    signupbutton.value = true;
    String email_value = email_controller.text.trim();
    String password_value = password_controller.text.trim();
    String cpassword_value = confirm_password_controller.text.trim();

    if (email_value == "" || password_value == "" || cpassword_value == "") {
      print('fields can\'t be empty');
      signupbutton.value = false;
    } else if (password_value != cpassword_value) {
      signupbutton.value = false;
      print('assword and confirm password should be same');
    } else {
      signUp(email_value, password_value);
    }
  }

  void signUp(String email, String password) async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newuser = UserModel(
        email: email,
        uid: uid,
        fullName: "",
        profilePicUrl: "",
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set(newuser.tomap())
          .then((value) {
        print('New User created');
        Get.to(completeProfilePage(
          usermodel: newuser,
          firebaseuser: credential!.user!,
        ));
      });
    } else {
      Get.snackbar('Error', 'Error in signup page');
    }

    // if (auth == null) {
    // } else {
    //   User firebaseuser = await auth.currentUser!;
    //   // print(firebaseuser!.uid.toString());

    //   try {
    //     // print('hi');

    //     credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: email,
    //       password: password,
    //     );
    //   } on FirebaseAuthException catch (e) {
    //     signupbutton.value = false;
    //     print('hi');
    //     Get.snackbar('Error', e.toString());
    //   }

    //   if (credential != null) {
    //     String uid = credential.user!.uid;
    //     UserModel userObject = UserModel(
    //       email: email,
    //       fullName: "",
    //       uid: uid,
    //       profilePicUrl: "",
    //     );
    //     var user = await FirebaseFirestore.instance
    //         .collection('Users')
    //         .doc(uid)
    //         .set(userObject.tomap())
    //         .then(
    //           (value) => {
    //             print('New User Created'),
    //             Get.snackbar('Success', 'Account Registration'),
    //             Get.to(
    //               completeProfilePage(
    //                 usermodel: userObject,
    //                 firebaseuser: firebaseuser,
    //               ),
    //             ),
    //           },
    //         );
    //     signupbutton.value = false;
    //   }
    // }
  }

  void uploadDataToFirestore(
    UserModel usermodel,
    User? firebaseuser,
    File imageFile,
  ) async {
    try {
      print('hi');
      submitbutton.value = true;

      UploadTask uploadTask = FirebaseStorage.instance
          .ref('ProfilePictureFolder')
          .child(usermodel.uid!)
          .putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String profilepicurl = await taskSnapshot.ref.getDownloadURL();
      String fullName = fullNameController.text.trim().toString();

      usermodel.profilePicUrl = profilepicurl;
      usermodel.fullName = fullName;
      // print(usermodel.uid);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(usermodel!.uid)
          .set(usermodel!.tomap())
          .then(
        (value) {
          print('Data updated sucsessfully');
          Get.snackbar('Success', 'Good');
          Get.offAll(
            Home_view(
              firebaseUser: firebaseuser!,
              userModel: usermodel,
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      submitbutton.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
