import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfirebase/common/snack_show.dart';
import 'package:socialfirebase/models/post.dart';
import 'package:socialfirebase/providers/firebase_crud_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socialfirebase/services/firebase_crud_service.dart';

class DetailPage extends ConsumerWidget {
  Post post;
  final types.User user;
  DetailPage(this.post, this.user);

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(singlePostStream(post.id));


    return Scaffold(
        backgroundColor: Colors.grey[350],
        body: Column(

          children: [
            Container(
                color: Colors.grey[300],
                height: 400,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                )),
            Expanded(
              child:   postData.when(
                  data: (data){
                    return data.comments.isEmpty ? Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No Comment"),
                    )) : ListView.builder(
                      physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.comments.length,
                        itemBuilder: (context, index) {
                          final comment = data.comments[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(comment.imageUrl),
                              ),
                              title: Text(comment.username),
                              subtitle: Text(comment.text),
                            ),
                          );
                        }
                    );
                  },
                  error: (err, stack) => Text('$err'),
                  loading: () => Container()
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: commentController,
                onFieldSubmitted: (val) {
                  if (val.isEmpty) {
                    SnackShow.showFailureSnack(context, "Add some comment");
                  } else {
                    ref.read(crudProvider.notifier).addComment(
                        id: post.id,
                        comment: Comment(
                            imageUrl: user.imageUrl!,
                            text: val,
                            username: user.firstName!));

                    commentController.clear();
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Write comment"),
              ),
            ),


          ],

    ));
  }
}
