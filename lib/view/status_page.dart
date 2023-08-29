

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/view/auth_page.dart';
import 'package:socialfirebase/view/home_page.dart';

import '../providers/firebase_auth_provider.dart';





class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Consumer(
            builder: (context, ref, child) {
              final userData = ref.watch(userStream);
              return userData.when(
                  data: (data){
                    if(data == null){
                      return AuthPage();
                    }else{
                      return HomePage();
                    }

                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())
              );
            }
        )
    );
  }
}