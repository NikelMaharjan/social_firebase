import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/common/snack_show.dart';
import 'package:socialfirebase/firebase_instances.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/providers/image_provider.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:socialfirebase/validation.dart';

class CreatePage extends ConsumerWidget with Validation {
  types.User user;


  CreatePage(this.user, {Key? key}) : super(key: key);


  final titleController = TextEditingController();
  final detailController = TextEditingController();

  final _form = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context, ref) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

    final image = ref.watch(imageProvider);
    final auth = ref.watch(crudProvider);


    ref.listen(crudProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
      if(next.errMessage.isNotEmpty){
        SnackShow.showFailureSnack(context, next.errMessage);
      }

      else if (next.isSuccess){
        Navigator.pop(context);
      }


    });

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //  backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
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


                ],
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
                      height:   deviceheight * 0.612,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                //  color: Colors.red,
                                height: deviceheight * 0.55  ,
                                child: Form(
                                  key: _form,
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 60.0),
                                        child: Text("Create Post",
                                          style: TextStyle(
                                              fontSize: 22, color: Color(0xff4252B5)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      _buildTextFormField(
                                        controller: titleController,
                                        hintText: 'Title',
                                        validator: validateTile,
                                      ),

                                      _buildTextFormField(
                                        maxLines: 3,
                                        controller: detailController,
                                        hintText: 'detail',
                                        validator: validateDescription,
                                      ),


                                      Expanded(
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
                                                    title: const Text('choose option'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickImage(true);
                                                          }, child: const Text('camera')),
                                                      TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                            ref.read(imageProvider.notifier).pickImage(false);
                                                          }, child: const Text('gallery')),
                                                    ],
                                                  );
                                                });
                                              },
                                              child: image != null ? Image.file(File(image.path)) : const Center(child: Text("Select an Image", style: TextStyle(color: Colors.grey),))),
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


                                          if(image == null){
                                            showDialog(context: context, builder: (context){

                                              return AlertDialog(
                                                content: const Text("Image is required"),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text("Close"))
                                                ],
                                              );

                                            });
                                          }

                                          else{

                                            ref.read(crudProvider.notifier).postAdd(
                                                createdBy: user.firstName!,
                                                title: titleController.text.trim(),
                                                detail: detailController.text.trim(),
                                                image: image,
                                                uid: FireInstances.fireAuth.currentUser!.uid
                                            );

                                          }

                                        }



                                      },
                                      child: auth.isLoad ? const CircularProgressIndicator() : const Text("Submit")))
                            ],
                          )
                      ),
                    ),
                  )),



            ],
          )),
    );
  }

  Widget _buildTextFormField({  String? Function(String?)? validator, int? maxLines,  required String hintText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            maxLines: maxLines ?? 1,
            textInputAction: TextInputAction.next,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: hintText,

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
