import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';

class firebase_helper{


  static Future<UserModel?> getCurrentUserModel(String uid)async{

    UserModel ? usermodel;
    DocumentSnapshot snapshot= await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if(snapshot.data()!=null)
    {
      usermodel= UserModel.fromMap(snapshot.data() as Map<String,dynamic>);

    }
    return usermodel;
  }
}