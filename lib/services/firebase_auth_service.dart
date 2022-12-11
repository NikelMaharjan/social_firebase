


import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialfirebase/exceptions/firebase_exception.dart';
import 'package:socialfirebase/firebase_instances.dart';

class FirebaseAuthService {



  static Future<Either<String, User>> userSignUp ({required String email, required String username, required String password, required XFile image,}) async{

    try{

      final imageId = DateTime.now().toString();    //image name which is stored in firebase, should be unique
      final ref = FireInstances.fireStorage.ref().child('userImage/$imageId');
      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();
      UserCredential credential = await FireInstances.fireAuth.createUserWithEmailAndPassword(   //this will create account in authentication
        email: email,
        password: password,
      );

      await FireInstances.fireChatCore.createUserInFirestore(   //this will create user model in firebase
        types.User(
            firstName: username,
            id: credential.user!.uid, // UID from Firebase Authentication
            imageUrl: imageUrl,
            metadata: {'email': email}),
      );
      return Right(credential.user!);          //we cant use Right(types.user) so we used firebase auth credential which contains different type of info. we have no use of that. so no need. can use Right(true)

    }

    on FirebaseAuthException catch(err){
     return Left(AuthExceptionHandler.handleException(err));

    }








  }


  static Future<Either<String, User>> userLogin({required String email,required String password,}) async {
    try {
      UserCredential credential = await FireInstances.fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(credential.user!);
    } on FirebaseAuthException catch (err) {
      return Left(AuthExceptionHandler.handleException(err));
    }
  }





}
