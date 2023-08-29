import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/services/firebase_crud_service.dart';

class UserDetailPage extends StatelessWidget {
  final types.User user;
  UserDetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: const Color(0xff4252B5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white,),
        title: Row(
          children: [
            Text(user.firstName!, style: const TextStyle(fontWeight: FontWeight.w600),),
            const SizedBox(width: 6,),
            const Icon(Icons.verified_rounded, color: Colors.white)
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bell)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.imageUrl!),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(user.firstName!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ),
                        Text(user.metadata!['email']),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildIcon(icon: CupertinoIcons.square_grid_4x3_fill),
                  buildIcon(icon: CupertinoIcons.videocam),
                  buildIcon(icon: CupertinoIcons.news),
                  buildIcon(icon: CupertinoIcons.profile_circled),
                ],
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final userPost = ref.watch(userPostStream(user.id));
                return userPost.when(
                    data: (data) {
                      return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3),
                          itemBuilder: (context, index) {
                            return Image.network(
                              data[index].imageUrl,
                              fit: BoxFit.fitHeight,
                            );
                          });
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => const CircularProgressIndicator());
              }),
            ),
          ],
        ),
      ),
    );
  }

  Icon buildIcon({required IconData? icon}) => Icon(icon, size: 30, color: Colors.grey[700],);
}
