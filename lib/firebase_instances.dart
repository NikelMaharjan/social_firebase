

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';



class FireInstances{

  static FirebaseAuth fireAuth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage fireStorage = FirebaseStorage.instance;
  static FirebaseChatCore fireChatCore = FirebaseChatCore.instance;
  static CollectionReference postDb = fireStore.collection('posts');

}