


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialfirebase/exceptions/firebase_exception.dart';
import 'package:socialfirebase/firebase_instances.dart';
import 'package:socialfirebase/models/post.dart';


final postStream = StreamProvider((ref) => FirebaseCrudService.streamPost);   //to display all post
final singlePostStream = StreamProvider.family((ref, String id) => FirebaseCrudService.streamSinglePost(postId: id));   //to display comment in real time
final userPostStream = StreamProvider.family((ref, String id) => FirebaseCrudService.streamUserPost(uid: id));   //to display user post

class FirebaseCrudService {

  static Future<Either<String, bool>> addPost ({required String title, required String createdBy, required String detail, required String uid, required XFile image}) async{

    try{

      final imageId = DateTime.now().toString();
      final ref = FireInstances.fireStorage.ref().child('postImage/$imageId');
      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();

      await FireInstances.postDb.add({ //this will save in firebase in below format. need to create post model to display in our app
        'created_by' : createdBy,
        'title': title,
        'detail': detail,
        'imageUrl':imageUrl,
        'uid': uid,
        'comments': [],
        'like':{
          'totalLikes': 0,
          'usernames': []
        },
        'imageId': imageId
      });
      return Right(true);

    }

    on FirebaseException catch(err){
      return Left(AuthExceptionHandler.handleException(err));

    }

  }


  static Future<Either<String, bool>> updatePost ({required String title, required String detail, required String postId, XFile? image, String? imageId}) async{

    try{


      if(image == null){

        await FireInstances.postDb.doc(postId).update({
          'title': title,
          'detail': detail,
        });
      }

      else {

        final oldRef = FireInstances.fireStorage.ref().child('postImage/$imageId');
        await oldRef.delete();
        final newImageId = DateTime.now().toString();
        final newRef = FireInstances.fireStorage.ref().child('postImage/$newImageId');
        await newRef.putFile(File(image.path));
        final imageUrl = await newRef.getDownloadURL();
        await FireInstances.postDb.doc(postId).update({
          'title': title,
          'detail': detail,
          'imageUrl': imageUrl,
          'imageId': newImageId
        });
      }

      return Right(true);



    }

    on FirebaseException catch(err){
      return Left(AuthExceptionHandler.handleException(err));

    }

  }

  static Future<Either<String, bool>> removePost({required String imageId, required String postId,}) async {
    try {
      final oldRef = FireInstances.fireStorage.ref().child('postImage/$imageId');
      await oldRef.delete();
      await FireInstances.postDb.doc(postId).delete();
      return Right(true);
    } on FirebaseAuthException catch (err) {
      return Left(AuthExceptionHandler.handleException(err));
    }
  }


  static Future<Either<String, bool>> addComment ({required String postId, required Comment comment}) async{

    try{

      await FireInstances.postDb.doc(postId).update({
        'comments': FieldValue.arrayUnion([comment.toJson()]), //pushing into array
      });

      return right(true);


    }

    on FirebaseException catch(err){
      return Left(AuthExceptionHandler.handleException(err));

    }

  }


  static Stream<List<Post>> get streamPost {

    try{

      final data = FireInstances.postDb.snapshots();
      return data.map((event) => event.docs.map((e) {  //need to display all the posts from all users. so we use double loop..event.docs is the document/post ids
        final json = e.data() as Map<String, dynamic>;   //e.data will give the post/document data..to get e.data we use loop in event.docs
        return Post(         //converting into post model to display. we dont create fromJson method in post model because we need post id(e.id) which is not present in post model
            imageUrl: json['imageUrl'],
            created_by: json['created_by'],
            uid: json['uid'],
            id: e.id,
            comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
            detail: json['detail'],
            like: Like.fromJson(json['like']),
            title: json['title'],
            imageId: json['imageId']
        );
      }).toList());


    }

    on FirebaseException catch(err){
      throw AuthExceptionHandler.handleException(err);
    }





  }

  static Stream<Post> streamSinglePost({required String postId}) {   //to show comment in realtime

    try{

      final data = FireInstances.postDb.doc(postId).snapshots();

      return data.map((e) {
        final json = e.data() as Map<String, dynamic>;

        return Post(
            imageUrl: json['imageUrl'],
            created_by: json['created_by'],
            uid: json['uid'],
            id: e.id,
            comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
            detail: json['detail'],
            like: Like.fromJson(json['like']),
            title: json['title'],
            imageId: json['imageId']
        );

      });




    }

    on FirebaseException catch(err){
      throw AuthExceptionHandler.handleException(err);
    }





  }


  static Stream<List<Post>> streamUserPost({required String uid}) {   //to show all posts created by user

    try{

      final data = FireInstances.postDb.where('uid', isEqualTo: uid).snapshots();   //'uid' is the field of the post and we compare it with user id
      return data.map((event) => event.docs.map((e) {
        final json = e.data() as Map<String, dynamic>;
        return Post(
            imageUrl: json['imageUrl'],
            created_by: json['created_by'],
            uid: json['uid'],
            id: e.id,
            comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
            detail: json['detail'],
            like: Like.fromJson(json['like']),
            title: json['title'],
            imageId: json['imageId']
        );
      }).toList());


    }

    on FirebaseException catch(err){
      throw AuthExceptionHandler.handleException(err);
    }





  }







}
