


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socialfirebase/common/snack_show.dart';
import 'package:socialfirebase/firebase_instances.dart';
import 'package:socialfirebase/models/post.dart';
import 'package:socialfirebase/providers/firebase_auth_provider.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/providers/form_validation_provider.dart';
import 'package:socialfirebase/providers/image_provider.dart';
import 'package:socialfirebase/providers/toggle_provider.dart';
import 'package:socialfirebase/validation.dart';


class EditPage extends ConsumerStatefulWidget with Validation {
  final Post post;
  EditPage(this.post, {Key? key}) : super(key: key);


  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {

  final _form = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();


  @override
  void initState() {
    titleController..text = widget.post.title;
    detailController..text = widget.post.detail;
    super.initState();
  }





  @override
  Widget build(BuildContext context) {

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
                                      Padding(
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
                                        validator: widget.validateTile,
                                      ),

                                      _buildTextFormField(
                                        maxLines: 3,
                                        controller: detailController,
                                        hintText: 'detail',
                                        validator: widget.validateDescription,
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
                                              child: image != null ? Image.file(File(image.path)) : Image.network(widget.post.imageUrl)),
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
                                           ref.read(crudProvider.notifier).updatePost(
                                               title: titleController.text.trim(),
                                               detail: detailController.text.trim(),
                                               id: widget.post.id
                                           );
                                          }

                                          else{

                                            ref.read(crudProvider.notifier).updatePost(
                                                title: titleController.text.trim(),
                                                detail: detailController.text.trim(),
                                                image: image,
                                                id: widget.post.id,
                                                imageId: widget.post.imageId,

                                            );

                                          }

                                        }






                                      },
                                      child: auth.isLoad ? CircularProgressIndicator() : const Text("Submit")))
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

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
