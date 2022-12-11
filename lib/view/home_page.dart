import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socialfirebase/providers/firebase_auth_provider.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:socialfirebase/services/firebase_crud_service.dart';
import 'package:socialfirebase/view/create_page.dart';
import 'package:socialfirebase/view/detail_page.dart';
import 'package:socialfirebase/view/edit_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socialfirebase/view/user_detail_page.dart';


import '../firebase_instances.dart';





class HomePage extends ConsumerWidget {
  final uid = FireInstances.fireAuth.currentUser!.uid;
  late types.User user;


  @override
  Widget build(BuildContext context, ref) {

    final friendData = ref.watch(friendStream);
    final userData = ref.watch(singleUserStream);
    final postData = ref.watch(postStream);
    return Scaffold(
      backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          // systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          //   statusBarColor: Colors.grey[300]
          // ),
          backgroundColor: const Color(0xff4252B5),
          title: const Text('Social Chat'),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey[300],
            child: userData.when(
                data: (data){
                  user = data;
                  return ListView(
                    children: [
                      SizedBox(
                        height: 220,
                        child: DrawerHeader(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: CachedNetworkImageProvider(data.imageUrl!), fit: BoxFit.fitWidth)
                              ),

                            )
                        ),
                      ),

                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        leading: const Icon(Icons.person),
                        title: Text(data.firstName!),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        leading: const Icon(Icons.mail),
                        title: Text(data.metadata!['email']),
                      ),

                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
                          Get.to(()=> CreatePage(user), transition: Transition.leftToRight);
                        },
                        leading: const Icon(Icons.add_box_outlined),
                        title: const Text("Create Post"),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.of(context).pop();
                          ref.read(authProvider.notifier).userLogout();
                        },
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Sign Out'),
                      )
                    ],
                  );
                },
                error: (err, stack) => Center(child: Text('$err')),
                loading: () => const Center(child: CircularProgressIndicator())
            )
        ),
        body: Column(
          children: [
            SizedBox(
              height: 116,
              child:  friendData.when(
                  data: (data){
                    return ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Get.to(()=> UserDetailPage(data[index]));
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundImage: CachedNetworkImageProvider( data[index].imageUrl!),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(data[index].firstName!)
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => const Center(child: CircularProgressIndicator())
              ),
            ),
            const Divider(color: Colors.grey,),

            Expanded(
                child: postData.when(
                    data: (data){
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              color: Colors.grey[350],
                              height: 410,
                              width: double.infinity,
                              child: data.isEmpty ? Center(child: Text("No data")) : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: DefaultTextStyle.of(context).style,
                                                children: [
                                                  TextSpan(text: 'Posted By ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  TextSpan(text: data[index].created_by),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 6,),

                                            Text(data[index].title,),
                                          ],
                                        ),
                                        if(uid == data[index].uid) IconButton(
                                            padding: EdgeInsets.all(0),
                                            constraints: BoxConstraints(),

                                            onPressed: (){

                                              showDialog(context: context, builder: (context){
                                                return AlertDialog(
                                                  backgroundColor: Colors.grey[300],
                                                  title: Text('choose option'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                          Get.to(() => EditPage(data[index]), transition: Transition.leftToRight);
                                                        }, child: Text('Edit')),
                                                    TextButton(
                                                        onPressed: (){

                                                          Navigator.of(context).pop();

                                                          showDialog(context: context, builder: (context){
                                                            return AlertDialog(
                                                              backgroundColor: Colors.grey[300],
                                                              title: Text("Sure"),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: (){
                                                                      ref.read(crudProvider.notifier).removePost(
                                                                          imageId: data[index].imageId,
                                                                          id: data[index].id
                                                                      );
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("Delete")
                                                                ),

                                                                TextButton(
                                                                    onPressed: (){
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("Cancel")
                                                                ),
                                                              ],

                                                            );

                                                          });










                                                        }, child: Text('Delete')),

                                                    TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        }, child: Text('Cancel')),
                                                  ],
                                                );
                                              });
                                            }, icon: Icon(Icons.more_horiz))
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Get.to(() => DetailPage(data[index], user), transition: Transition.leftToRight);
                                    },
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      imageUrl: data[index].imageUrl, fit: BoxFit.cover, height: 300, width: double.infinity,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                                    child: Text(data[index].detail, overflow: TextOverflow.ellipsis,),
                                  )
                                ],
                              ),
                            );
                          }
                      );
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => Center(child: CircularProgressIndicator(),)
                )
            )
          ],
        )
    );
  }
}