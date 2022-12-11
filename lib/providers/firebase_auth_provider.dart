import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialfirebase/firebase_instances.dart';
import 'package:socialfirebase/models/auth_state.dart';
import 'package:socialfirebase/services/firebase_auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final userStream = StreamProvider.autoDispose((ref) => FireInstances.fireAuth.authStateChanges()); //to check whether user is logged in or not. provided by firebase auth itself
final friendStream = StreamProvider.autoDispose((ref) => FireInstances.fireChatCore.users()); //to display list of users which is not logged in. provided by chatcore

final singleUserStream = StreamProvider.autoDispose((ref) { //to display user which is logged
  final uid = FirebaseChatCore.instance.firebaseUser!.uid; //uid of logged in user
  final data = FireInstances.fireStore.collection('users').doc(uid).snapshots();
  return data.map((event) {
    final json = event.data() as Map<String, dynamic>; //event only provides users user/document id(event.id). event.data gives user/document data (which will be in map). so need to use loop to get event.data and covert into model
    return types.User(
        id: event.id,
        metadata: json['metadata'],
        firstName: json['firstName'],
        imageUrl: json['imageUrl']);
  });
});

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
    (ref) => AuthProvider(AuthState.initState()));

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(super.state);

  Future<void> userSignUp({
    required String email,
    required String password,
    required XFile image,
    required String username,
  }) async {
    state = state.copyWith(isLoad: true, errMessage: '');
    final response = await FirebaseAuthService.userSignUp(
        email: email, username: username, password: password, image: image);

    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false,
          user: r,
          errMessage: ''); //user : r is not used at all at this moment. no need
    });
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoad: true, errMessage: '');
    final response =
        await FirebaseAuthService.userLogin(email: email, password: password);

    response.fold((l) {
      state = state.copyWith(isLoad: false, errMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, errMessage: '', user: r);
    });
  }

  Future<void> userLogout() async {
    await FireInstances.fireAuth.signOut();
  }
}
