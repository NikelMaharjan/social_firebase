import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/firebase_options.dart';
import 'package:socialfirebase/view/auth_page.dart';
import 'package:get/get.dart';
import 'package:socialfirebase/view/status_page.dart';

import 'constants.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xff4252B5)));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const ProviderScope(child: Home()));


}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    // devicewidth = MediaQuery.of(context).size.width;

    return  const GetMaterialApp(

        debugShowCheckedModeBanner: false, home: StatusPage());
  }
}
