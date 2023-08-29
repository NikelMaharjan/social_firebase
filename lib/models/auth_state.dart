



import 'package:firebase_auth/firebase_auth.dart';

class AuthState {

  final bool isLoad;
  final String errMessage;






  AuthState({required this.errMessage, required this.isLoad});


  AuthState.initState() : isLoad = false, errMessage = "";


  AuthState copyWith({bool? isLoad, User? user, String? errMessage}){
    return AuthState(
        errMessage: errMessage ?? this.errMessage,
        isLoad: isLoad ?? this.isLoad,

    );
  }



}