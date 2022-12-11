



import 'package:firebase_auth/firebase_auth.dart';

class AuthState {

  final bool isLoad;
  final String errMessage;
  final User? user;     //user is not used in app right now






  AuthState({required this.errMessage,  this.user, required this.isLoad});


  AuthState.initState() : isLoad = false, errMessage = "", user = null;


  AuthState copyWith({bool? isLoad, User? user, String? errMessage}){
    return AuthState(
        errMessage: errMessage ?? this.errMessage,
        isLoad: isLoad ?? this.isLoad,
        user:  user ?? this.user

    );
  }



}