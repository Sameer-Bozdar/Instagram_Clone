import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_project/constants/comment_card.dart';
import 'package:instagram_project/models/user_model.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/resources/firestore_methods.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:provider/provider.dart';


class CommentScreen extends StatefulWidget {
  final snap ;
   CommentScreen({super.key ,required this.snap});


  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

TextEditingController _controller = TextEditingController();

class _CommentScreenState extends State<CommentScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
      centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts')
            .doc(widget.snap['postid'])
            .collection('comments').orderBy('datePublished',descending: true)
            .snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(itemCount: (snapshot.data as dynamic).docs.length, itemBuilder: (context, index)=> CommentCard(
            snap: (snapshot.data as dynamic).docs[index].data()

          ));

        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8,),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'comment as ${user.username}',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  await FirestoreMethods().postComment(
                      widget.snap['postid'],
                      _controller.text,
                      user.uid,
                      user.username,
                      user.photoUrl,

                  );
                  setState(() {
                    _controller.text = "";
                  });
                },
                child: Container(
                  padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child:const Text('Post', style:  TextStyle(color: blueColor),),
                ),
              )
          ],),
        ),
      ),
    );
  }
}
