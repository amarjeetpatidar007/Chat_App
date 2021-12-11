
import 'package:app_provider/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseHelper{

  static Future<UserModel?> getUserById(String uid) async{
    UserModel? userModel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if(documentSnapshot.data() != null){
      userModel = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}