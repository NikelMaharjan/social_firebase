




 import 'package:flutter_riverpod/flutter_riverpod.dart';


final loginProvider = StateNotifierProvider<ToggleProvider, bool>((ref) => ToggleProvider(true));




class ToggleProvider extends StateNotifier<bool>{
  ToggleProvider(super.state);

  void toggle(){

    state = !state;

  }




}