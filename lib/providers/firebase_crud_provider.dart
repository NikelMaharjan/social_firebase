




import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialfirebase/models/post.dart';
import 'package:socialfirebase/models/post_state.dart';
import 'package:socialfirebase/services/firebase_crud_service.dart';





final crudProvider = StateNotifierProvider<CrudProvider, PostState>((ref) => CrudProvider(PostState.initState()));


class CrudProvider extends StateNotifier<PostState>{
  CrudProvider(super.state);



  Future<void> postAdd({required String title, required String detail, required XFile image, required String uid, required String createdBy,}) async {

    state = state.copyWith(isLoad: true, errMessage: '', isSuccess: false);
    final response = await FirebaseCrudService.addPost(title: title, detail: detail, image: image, uid: uid, createdBy: createdBy);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith( isLoad: false, errMessage: '', isSuccess: r);
    });

  }

  Future<void> updatePost({required String title, required String detail, XFile? image, String? imageId, required String id,}) async {

    state = state.copyWith(isLoad: true, errMessage: '', isSuccess: false);
    final response = await FirebaseCrudService.updatePost(title: title, detail: detail, image: image, postId: id, imageId: imageId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, errMessage: '', isSuccess: r);
    });

  }


  Future<void> removePost({required String imageId, required String id,}) async {

    state = state.copyWith(isLoad: true, errMessage: '', isSuccess: false);
    final response = await FirebaseCrudService.removePost(postId: id, imageId: imageId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, errMessage: '', isSuccess: r);
    });

  }

  Future<void> addComment({required String id, required Comment comment,}) async {

    state = state.copyWith(isLoad: true, errMessage: '', isSuccess: false);
    final response = await FirebaseCrudService.addComment(comment: comment, postId: id);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, errMessage: '', isSuccess: r);
    });
  }


}