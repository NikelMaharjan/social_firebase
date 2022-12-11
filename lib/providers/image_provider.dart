




import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);


  void pickImage(bool isCamera) async {


    final ImagePicker _picker = ImagePicker();
    if(isCamera){
      state = await _picker.pickImage(source: ImageSource.camera);
    }else{
      state = await _picker.pickImage(source: ImageSource.gallery);
    }







  }

}