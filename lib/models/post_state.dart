

class PostState{

  final bool isLoad;
  final String errMessage;
  final bool isSuccess;


  PostState({required this.isLoad, required this.errMessage, required this.isSuccess});


  PostState.initState() : isSuccess = false, errMessage = '', isLoad = false;


  PostState copyWith({bool? isLoad, bool? isSuccess, String? errMessage}){
    return PostState(
        isLoad: isLoad ?? this.isLoad,
        errMessage: errMessage ?? this.errMessage,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }






}