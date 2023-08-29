import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/common/snack_show.dart';
import 'package:socialfirebase/providers/firebase_auth_provider.dart';
import 'package:socialfirebase/providers/form_validation_provider.dart';
import 'package:socialfirebase/providers/image_provider.dart';
import 'package:socialfirebase/providers/toggle_provider.dart';
import 'package:socialfirebase/validation.dart';

class AuthPage extends ConsumerWidget with Validation {
   AuthPage({Key? key}) : super(key: key);

   final nameController = TextEditingController();
   final passController = TextEditingController();
   final mailController = TextEditingController();

   final _form = GlobalKey<FormState>();





   @override
  Widget build(BuildContext context, ref) {

     final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
     final devicewidth = MediaQuery.of(context).size.width;

     final isLogin = ref.watch(loginProvider);
     final isVisible = ref.watch(validateProvider);
     final image = ref.watch(imageProvider);
     final auth = ref.watch(authProvider);


     ref.listen(authProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
       if(next.errMessage.isNotEmpty){
         SnackShow.showFailureSnack(context, next.errMessage);
       }

     });

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: deviceheight * 0.33,
                color: const Color(0xff4252B5),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Image.asset(
                        'assets/images/firebaseicon.png',
                        height: deviceheight * 0.1,
                      ),
                    )),
              ),
              Positioned(
                  right: devicewidth * 0.08,
                  left: devicewidth * 0.08,
                  top: deviceheight * 0.21,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      //  color: Colors.red,
                      height:  isLogin ? deviceheight * 0.48 : deviceheight * 0.612,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                              //  color: Colors.red,
                                height: isLogin ? deviceheight * 0.42 : deviceheight * 0.55  ,
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    children: [
                                       Padding(
                                        padding: EdgeInsets.only(top: 60.0),
                                        child: Text(isLogin ? "Login" : 'Signup',
                                          style: TextStyle(
                                              fontSize: 22, color: Color(0xff4252B5)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      if(!isLogin) _buildTextFormField(
                                        obscureText: false,
                                          controller: nameController,
                                          hintText: 'Name',
                                         validator: validateUserName,
                                          prefixIcon: CupertinoIcons.person),

                                      _buildTextFormField(
                                        obscureText: false,
                                        controller: mailController,
                                          hintText: 'Email',
                                         validator: validateEmail,
                                          prefixIcon: CupertinoIcons.mail),

                                      _buildTextFormField(
                                        onTap: (){
                                          ref.read(validateProvider.notifier).visible();
                                        },
                                        controller:  passController,
                                          hintText: "Password",
                                         validator: validatePassword,
                                          obscureText: isVisible,
                                          prefixIcon: CupertinoIcons.padlock,
                                          suffixIcon: isVisible ? Icons.visibility_off : Icons.visibility
                                      ),
                                      if(!isLogin)  Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            //color: Colors.green,

                                              border: Border.all(color: Colors.grey)
                                          ),
                                       //   height: deviceheight * 0.15,

                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white
                                              ),
                                              onPressed: (){
                                                showDialog(context: context, builder: (context){
                                                  return AlertDialog(
                                                    title: Text('choose option'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickImage(true);
                                                          }, child: Text('camera')),
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickImage(false);
                                                          }, child: Text('gallery')),
                                                    ],
                                                  );
                                                });
                                              },
                                              child: image != null ? Image.file(File(image.path)) : Center(child: Text("Select an Image", style: TextStyle(color: Colors.grey),))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(
                                                  15)), // <-- Radius
                                        ),
                                        backgroundColor: const Color(0xff4252B5),
                                        minimumSize: const Size(double.infinity, 0),
                                      ),
                                      onPressed:  auth.isLoad ? null : ()  async {
                                        _form.currentState!.save();
                                        if(_form.currentState!.validate()){

                                          if(isLogin){
                                            //login method


                                            ref.read(authProvider.notifier).userLogin(
                                                email: mailController.text.trim(),
                                                password: passController.text.trim(),
                                            );


                                          }

                                          else{
                                            if(image == null){
                                              showDialog(context: context, builder: (context){

                                                return AlertDialog(
                                                  content: Text("Image is required"),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: Text("Close"))
                                                  ],
                                                );

                                              });
                                            }

                                            else{
                                              //signup method
                                              
                                              ref.read(authProvider.notifier).userSignUp(
                                                  email: mailController.text.trim(),
                                                  password: passController.text.trim(),
                                                  image: image,
                                                  username: nameController.text.trim()
                                              );


                                            }

                                          }




                                        }

                                        else{

                                        }
                                      },
                                      child: auth.isLoad ? CircularProgressIndicator() : const Text("Submit")))
                            ],
                          )
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                         isLogin ? "Don\'t Have a Account?" : 'Already Have an account',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              _form.currentState!.reset();
                              nameController.clear();
                              passController.clear();
                              mailController.clear();
                              ref.read(loginProvider.notifier).toggle();
                              },
                            child:  Text(
                              isLogin ? "Sign Up" : "Login",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  )),
            ],
          )),
    );
  }

  Widget _buildTextFormField({required IconData prefixIcon, required bool obscureText,  VoidCallback? onTap, String? Function(String?)? validator, IconData? suffixIcon,  required String hintText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            textInputAction: TextInputAction.next,
           validator: validator,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintText: hintText,
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: Icon(suffixIcon),
                onPressed: onTap,
                color: Colors.black,

              )
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
